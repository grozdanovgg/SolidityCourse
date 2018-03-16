pragma solidity ^0.4.21;

contract Courses   {
    
    enum PokemonChoice { a,b,c,d,e,f,g }
    
    mapping (address => PokemonChoice[])  ownerPokemons;
    mapping (address => uint) lastPokemonCath;
    mapping (uint8 => address[]) pokemonOwners;
    
    modifier inputMinimumTimeout {
        require(now - lastPokemonCath[msg.sender] > 15 seconds);
        _;
    }
    
    modifier noDuplicatesPokemons (PokemonChoice _tryPokemon) {
        PokemonChoice[] storage userCurrentPokemons = ownerPokemons[msg.sender];
        
        for (uint8 i = 0; i < userCurrentPokemons.length; i +=1) {
            require(userCurrentPokemons[i] != _tryPokemon);
        }
        _;
    }
    
    function catchPokemon (PokemonChoice _pokemon) public inputMinimumTimeout noDuplicatesPokemons(_pokemon){
        ownerPokemons[msg.sender].push(_pokemon);
        lastPokemonCath[msg.sender] = now;
        pokemonOwners[uint8(_pokemon)].push(msg.sender);
    }
    
    function getMyPokemons () public view returns (PokemonChoice[]) {
        return ownerPokemons[msg.sender];
    }
    
    function getPokemonOwners(PokemonChoice _pokemon) returns(address[]) {
        return pokemonOwners[uint8(_pokemon)];
    }
}
