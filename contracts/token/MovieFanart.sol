pragma solidity ^0.8.0;

import "./ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract MovieFanart is ERC721PresetMinterPauserAutoId {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    mapping(uint256 => uint256) profit;
    mapping(uint256 => uint) proportion;//proportion == 1 means 1% of profit will be given to movie owner
    mapping(uint256 => address) movieAddr;
    mapping(uint256 => uint256) movieID;
    mapping(uint256 => string) fanartURI;
    
    
    constructor() ERC721PresetMinterPauserAutoId("MovieFanart", "MF", "http://developer.mathwallet.org/bsc/nfttest/") 
    {}
    
    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "web3 CLI: must have minter role to update tokenURI");
        setTokenURI(tokenId, tokenURI);
    }
    
    function publishFanart(address to, string memory _fanartURI, uint256 mTokenID, uint256 _profit, uint _proportion) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
        uint256 tokenID = _tokenIdTracker.current();
        ERC721._mint(to, tokenID);
        setTokenURI(tokenID ,_fanartURI);
        _tokenIdTracker.increment();
        profit[tokenID] = _profit;
        //TODO:finish getMinProportion for Movie
        //require(_proportion >= getMinProportion(mTokenID), "Proportion less than minimal");
        proportion[tokenID] = _proportion;
        fanartURI[tokenID] = _fanartURI;
        movieID[tokenID] = mTokenID;
        movieAddr[tokenID] = ownerOf(mTokenID);
    }
    
    function rewardFanart(uint256 _tokenID) public payable {
        address payable _fanartAddr = (address payable)ownerOf(_tokenID);
        address payable _movieAddr = (address payable)movieAddr[_tokenID];
        uint profitToMovie = msg.value*(proportion[_tokenID])/100;
        _fanartAddr.transfer(msg.value-profitToMovie);
        _movieAddr.transfer(profitToMovie);
    }
    
    
    
    function getMsgSender() public view returns (address){
        return _msgSender();
    }
    
    function getMovieAddr(uint256 _tokenID) public view returns (address){
        return movieAddr[_tokenID];
    }
    
    function getFanartInfo(uint256 _tokenID) public view returns (string memory){
        return fanartURI[_tokenID];
    }
    
    
}