pragma solidity ^0.4.19;

contract Master {
    address private owner;
    Agent[] private agents;
    mapping (address => Master) agentsMaster;
    
    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier NoDuplicatesAgents (Agent _agent){
        require(this != agentsMaster[_agent]);
        _;
    }
    
    modifier ApprovedAgent (Agent _agent){
        require(this == agentsMaster[_agent]);
        _;
    }
    
    function Master() public{
        owner = msg.sender;
    }
    
    function createAgent() public OnlyOwner {
        Agent agent = new Agent(this);
        agents.push(agent);
        agentsMaster[agent] = this;
    }
    
    function approveAgent (Agent _agent) public OnlyOwner NoDuplicatesAgents(_agent){
        if(_agent.getCurrentMaster() == address(this)){
            agents.push(_agent);
            agentsMaster[_agent] = this;
        }
    }
    
    function agentWait (Agent _agent) public OnlyOwner ApprovedAgent(_agent){
        _agent.wait();
    }
    
    function isTaskReady (Agent _agent) public view OnlyOwner ApprovedAgent(_agent){
        _agent.isTaskReady();
    }
    
    function getAllAgents () public view returns(Agent[]) {
        return agents;
    }
}

contract Agent {
    uint startedToWait;
    address public owner;
    Master public master;
    
    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier MasterControl {
        require(master == msg.sender);
        _;
    }
    
    function Agent(Master _master) public {
        owner = msg.sender;
        master = _master;
    }
    
    function wait () public MasterControl{
        startedToWait = now;
    }
    
    function isTaskReady () public view MasterControl returns(bool){
        if(startedToWait + 15 seconds < now){
            return true;
        } else {
            return false;
        }
    }
    
    function changeMaster (Master _newMaster) public OnlyOwner{
        master = _newMaster;
    }
    
    function getCurrentMaster () public view returns(address){
        return master;
    }
}
