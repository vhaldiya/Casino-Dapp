pragma solidity 0.5.0;

contract Casino {
   address owner;
   uint256 public minimumBet = 100 finney;
   uint256 public totalBet;
   uint256 public numberOfBets;
   uint256 public maxAmountOfBets = 2;
   address[] public players;
   uint public numberWinner = 0;
   uint public constant LIMIT_AMOUNT_BETS = 100;
  // uint8[] public numbers;
  
  // Each number has an array of players. Associate each number with a bunch of players
   mapping(uint => address payable[]) numberBetPlayers;

   // The number that each player has bet for
   //mapping(address => uint) playerBetsNumber;
  
   
   modifier onEndGame(){
      if(numberOfBets >= maxAmountOfBets) _;
    }
   
   constructor(uint256 _minimumBet, uint _maxAmountOfBets) public {
      owner = msg.sender;
	  if(_minimumBet != 0 ) minimumBet = _minimumBet;
	  if(_maxAmountOfBets > 0 && _maxAmountOfBets <= LIMIT_AMOUNT_BETS) maxAmountOfBets = _maxAmountOfBets;
   }
   function kill() public {
      if(msg.sender == owner) {
			address payable owner_add = msg.sender;
			selfdestruct(owner_add);
	  }
   }
   
   function checkPlayerExists(address player) public view returns(bool){
     for(uint256 i = 0; i < players.length; i++){
         if(players[i] == player) return true;
      }
      return false;
   }
   
   // To bet for a number between 1 and 10 both inclusive
   function bet(uint numberToBet) public payable {
      require(!checkPlayerExists(msg.sender));
      require(numberToBet >= 1 && numberToBet <= 10);
      require(msg.value >= minimumBet);
      // playerBetsNumber[msg.sender] = numberToBet;
       numberBetPlayers[numberToBet].push(msg.sender);
       players.push(msg.sender);
      numberOfBets++;
      totalBet += msg.value;
	  if(numberOfBets >= maxAmountOfBets) generateNumberWinner();
   }
   // Generates a number between 1 and 10 that will be the winner
   function generateNumberWinner() public onEndGame {
      
	 //   uint8 randomNumber = numbers[0];
     //   for (uint8 i = 1; i < numbers.length; ++i) {
     //      randomNumber ^= numbers[i];
     //   }
	  numberWinner = 5;
	  //uint256 numberGenerated = block.number % 10 + 1; // This isn't secure
     // distributePrizes((randomNumber%10));
	 distributePrizes();
   }
   
   // Sends the corresponding ether to each winner depending on the total bets
   function distributePrizes() public {
       uint winnerEtherAmount = totalBet / numberBetPlayers[numberWinner].length;
     for(uint i = 0; i < numberBetPlayers[numberWinner].length; i++){
         numberBetPlayers[numberWinner][i].transfer(winnerEtherAmount);
      }

      // Delete all the players for each number
      for(uint j = 1; j <= 10; j++){
         numberBetPlayers[j].length = 0;
      }

	  totalBet = 0;
	  players.length = 0;
	  numberOfBets = 0;
   }
   // Fallback function in case someone sends ether to the contract so it doesn't get lost and to increase the treasury of this contract that will be distributed in each game
   //function() public payable {
//		
  // }
}
