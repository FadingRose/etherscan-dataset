# pragma version 0.3.10
"""
@title Arbitrum Broadcaster
@author CurveFi
@license MIT
@custom:version 1.0.1
"""


version: public(constant(String[8])) = "1.0.1"


interface IArbInbox:
    def calculateRetryableSubmissionFee(_data_length: uint256, _base_fee: uint256) -> uint256: view


event Broadcast:
    chain_id: indexed(uint256)
    agent: indexed(Agent)
    messages: DynArray[Message, MAX_MESSAGES]

event SetDestinationData:
    chain_id: indexed(uint256)
    data: DestinationData

event ApplyAdmins:
    admins: AdminSet

event CommitAdmins:
    future_admins: AdminSet


enum Agent:
    OWNERSHIP
    PARAMETER
    EMERGENCY


struct AdminSet:
    ownership: address
    parameter: address
    emergency: address

struct Message:
    target: address
    data: Bytes[MAX_BYTES]

struct DestinationData:
    arb_inbox: IArbInbox
    arb_refund: address  # DAO owned Vault for example
    relayer: address


MAX_BYTES: constant(uint256) = 1024
MAX_MESSAGES: constant(uint256) = 8
MAXSIZE: constant(uint256) = 16384


admins: public(AdminSet)
future_admins: public(AdminSet)

destination_data: public(HashMap[uint256, DestinationData])
agent: HashMap[address, Agent]


@payable
@external
def __init__(_admins: AdminSet):
    assert _admins.ownership != _admins.parameter  # a != b
    assert _admins.ownership != _admins.emergency  # a != c
    assert _admins.parameter != _admins.emergency  # b != c

    self.admins = _admins

    self.agent[_admins.ownership] = Agent.OWNERSHIP
    self.agent[_admins.parameter] = Agent.PARAMETER
    self.agent[_admins.emergency] = Agent.EMERGENCY

    log ApplyAdmins(_admins)


@external
def broadcast(_chain_id: uint256, _messages: DynArray[Message, MAX_MESSAGES], _gas_limit: uint256, _max_fee_per_gas: uint256, _destination_data: DestinationData=empty(DestinationData)):
    """
    @notice Broadcast a sequence of messages.
    @param _chain_id Chain ID of L2
    @param _messages The sequence of messages to broadcast.
    @param _gas_limit The gas limit for the execution on L2.
    @param _max_fee_per_gas The maximum gas price bid for the execution on L2.
    @param _destination_data Specific DestinationData (self.destination_data by default)
    """
    agent: Agent = self.agent[msg.sender]
    assert agent != empty(Agent)
    destination: DestinationData = _destination_data
    if destination.relayer == empty(address):
        destination = self.destination_data[_chain_id]
    assert destination.relayer != empty(address)

    # define all variables here before expanding memory enormously
    submission_cost: uint256 = 0

    data: Bytes[MAXSIZE] = _abi_encode(
        agent,
        _messages,
        method_id=method_id("relay(uint256,(address,bytes)[])"),
    )
    submission_cost = destination.arb_inbox.calculateRetryableSubmissionFee(len(data), block.basefee)

    # NOTE: using `unsafeCreateRetryableTicket` so that refund address is not aliased
    raw_call(
        destination.arb_inbox.address,
        _abi_encode(
            destination.relayer,  # to
            empty(uint256),  # l2CallValue
            submission_cost,  # maxSubmissionCost
            destination.arb_refund,  # excessFeeRefundAddress
            destination.arb_refund,  # callValueRefundAddress
            _gas_limit,
            _max_fee_per_gas,
            data,
            method_id=method_id("unsafeCreateRetryableTicket(address,uint256,uint256,address,address,uint256,uint256,bytes)"),
        ),
        value=submission_cost + _gas_limit * _max_fee_per_gas,
    )


@external
def set_destination_data(_chain_id: uint256, _destination_data: DestinationData):
    """
    @notice Set destination data for child chain.
    """
    assert msg.sender == self.admins.ownership
    self.destination_data[_chain_id] = _destination_data
    log SetDestinationData(_chain_id, _destination_data)


@external
def commit_admins(_future_admins: AdminSet):
    """
    @notice Commit an admin set to use in the future.
    """
    assert msg.sender == self.admins.ownership

    assert _future_admins.ownership != _future_admins.parameter  # a != b
    assert _future_admins.ownership != _future_admins.emergency  # a != c
    assert _future_admins.parameter != _future_admins.emergency  # b != c

    self.future_admins = _future_admins
    log CommitAdmins(_future_admins)


@external
def apply_admins():
    """
    @notice Apply the future admin set.
    """
    admins: AdminSet = self.admins
    assert msg.sender == admins.ownership

    # reset old admins
    self.agent[admins.ownership] = empty(Agent)
    self.agent[admins.parameter] = empty(Agent)
    self.agent[admins.emergency] = empty(Agent)

    # set new admins
    future_admins: AdminSet = self.future_admins
    self.agent[future_admins.ownership] = Agent.OWNERSHIP
    self.agent[future_admins.parameter] = Agent.PARAMETER
    self.agent[future_admins.emergency] = Agent.EMERGENCY

    self.admins = future_admins
    log ApplyAdmins(future_admins)


@payable
@external
def __default__():
    assert len(msg.data) == 0
