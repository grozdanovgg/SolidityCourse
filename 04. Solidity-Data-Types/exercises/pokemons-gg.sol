pragma solidity ^0.4.21;

contract Courses   {
    
//   struct Instructor {
//         uint age;
//         string fName;
//         string lName;
//     }
    
//     mapping (address => Instructor) instructors;
    
//     function setInstructor(address _address, uint _age, string _fName, string _lName) public {
//         var instructor = instructors[_address];
        
//         instructor.age = _age;
//         instructor.fName = _fName;
//         instructor.lName = _lName;
        
//     }
    
//     function getInstructor(address _address) view public returns (uint, string, string) {
//         return (instructors[_address].age, instructors[_address].fName, instructors[_address].lName);
//     }
    
    enum PokemonChoice { a,b,c,d,e,f,g }
    
    mapping (address => Pokemon[]) public ownerPokemons;
    
    struct Pokemon {
        PokemonChoice name;
    }
    
    function catchPokemon(PokemonChoice pokemonCatched){
        ownerPokemons[msg.sender] = [ Pokemon(PokemonChoice.a)];
    }
    
    
}
