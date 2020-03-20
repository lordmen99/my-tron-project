// Solidiy varsion allowed by the compiler.
// Smart Contract SendMessages written and compiled using Truffle
//
// v 0.1. on 18.03.2020
//
pragma solidity >=0.4.21 <0.6.0;

contract SendMessages {
  // Struct  is intended to define a new type of structure or variable type
  struct message {
    address from;
    string  text;
    uint256 time;
  }

  // A very similar structure for the hashIPFS
  struct hashIPFS {
    address from;
    string hash;
    uint256 time;
  }

  // the event allows to make public and available the Message and the HashIPFS using RPC commands
  event Message(address indexed _sender, address indexed _receiver, uint256 _time, string message);
  event HashIPFS(address indexed _sender, address indexed _receiver, uint256 _time, string hashIPFS);

  // We define the mapping, one between an addresss and an integer for indexing the messages
  //and another one for mapping the address and the messages. 
  mapping (address => uint256) public last_msg_index;
  mapping (address => uint256) public last_hash_index;
  mapping (address => mapping (uint256 => message)) public messages;
  mapping (address => mapping (uint256 => hashIPFS)) public hashesIPFS;

  // A function for sending a message to the receiver. Where the mapping are used to store 
  // the variables from, text and time in a message struct.
  function sendMessage(address _receiver, string memory _text) public  {
    messages[_receiver][last_msg_index[_receiver]].from = msg.sender;
    messages[_receiver][last_msg_index[_receiver]].text = _text;
    messages[_receiver][last_msg_index[_receiver]].time = now;
    last_msg_index[_receiver]++;
    emit Message(msg.sender, _receiver, now, _text);
  }

  // A funtion that returns a true or false. It checks in the messages mapping if there 
  // is a new message for the receiver address. 
  function isThereANewMessage(address _receiver, uint256 _index) view public returns (bool) {
    return messages[_receiver][_index].time  > now;
  }

  // Return the last index of the mapping. This is, the index of the last message received. 
  function lastIndex(address _receiver) view public returns (uint256) {
    return last_msg_index[_receiver];
  }

  // This function returns the last message received by the receiver addess
  function getLastMessage(address _receiver) view  public returns (address, string memory, uint256) {
    require(last_msg_index[_receiver] > 0);
    return (messages[_receiver][last_msg_index[_receiver] - 1].from, messages[_receiver][last_msg_index[_receiver] - 1].text, messages[_receiver][last_msg_index[_receiver] - 1].time);
  }
  // This function returns a message received by the receiver addess accesed by an index
  function getMessageByIndex(address _receiver, uint256 _index) view public returns (address, string memory, uint256) {
    return (messages[_receiver][_index - 1].from, messages[_receiver][_index - 1].text, messages[_receiver][_index - 1].time);
  }

  // Similarly to sendMessage, this function sends a hash string to the receiver
  function sendIPFSFile(address _receiver, string memory _hash) public  {
    hashesIPFS[_receiver][last_msg_index[_receiver]].from = msg.sender;
    hashesIPFS[_receiver][last_msg_index[_receiver]].hash = _hash;
    hashesIPFS[_receiver][last_msg_index[_receiver]].time = now;
    last_hash_index[_receiver]++;
    emit HashIPFS(msg.sender, _receiver, now, _hash);
  }

}