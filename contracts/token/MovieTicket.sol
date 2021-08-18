pragma solidity ^0.8.0;

import "./ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract MovieTicket is ERC721PresetMinterPauserAutoId {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    
    constructor() ERC721PresetMinterPauserAutoId("MovieTicket", "MT", "http://developer.mathwallet.org/bsc/nfttest/") 
    {}
    
    // This allows the minter to update the tokenURI after it's been minted.
    // To disable this, delete this function.
    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "web3 CLI: must have minter role to update tokenURI");
        setTokenURI(tokenId, tokenURI);
    }
    
    function mintMovieTicket(address to, string memory tokenURI, uint256 ticketNum) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
        require(ticketNum > 0, "MovieTicket: must mint at least one ticket");
        for(uint256 i = 0; i < ticketNum; i++){
            uint256 tokenID = _tokenIdTracker.current();
            ERC721._mint(to, tokenID);
            setTokenURI(tokenID ,tokenURI);
            _tokenIdTracker.increment();
        }
    }
    
    
    function getDefaultAdminRole() public view returns(address){
            // TODO
    }
    
    function getMsgSender() public view returns (address){
        return _msgSender();
    }
    
    
}