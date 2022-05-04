// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SbitNFT is ERC1155 {
    constructor() ERC1155("https://mainnet.sbit.dev/api/item/{id}.json") {
    }

    struct WalletNFTInfo {
        uint256 NFTId;
        string name;
        string url;
        string desc;
        uint256 createAt;
        uint32 count;
    }

    WalletNFTInfo[] public walletNFTList;

    function createNFT(address owner, string memory name, string memory url, string memory desc, uint32 count) public {
        require(count <= 10 && count > 0);
        uint NFTId = _generateNFTId(name, url);
        walletNFTList.push(WalletNFTInfo(NFTId, name, url, desc, block.timestamp, count));
        uint id = walletNFTList.length - 1;
        _mint(owner, id, count, "");
    }

    function getNFTListByOwner(address owner, uint fromIndex, uint take) external view returns (uint256[] memory, uint) {
        uint256[] memory result = new uint256[](take);
        uint counter = 0;
        uint curIndex = fromIndex;
        for (uint index = curIndex; index < walletNFTList.length; index++) {
            curIndex = index;
            if (counter > take) {
                return (result, curIndex);
            }
            if (balanceOf(owner, curIndex) > 0) {
                result[counter] = index;
                counter++;
            }
        }
        return (result, curIndex);
    }

    function batchNFTInfoByIds(address owner, uint[] memory _ids) public view returns (WalletNFTInfo[] memory) {
        WalletNFTInfo[] memory result = new WalletNFTInfo[](_ids.length);
        uint counter = 0;
        for (uint index = 0; index < _ids.length; index++) {
            uint id = _ids[index];
            if(walletNFTList[id].count > 0) {
                result[counter] = walletNFTList[id];
                result[counter].count = uint32(balanceOf(owner, id));
                counter++;
            }
        }
        return result;
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) public {
        ERC1155.safeTransferFrom(from, to, id, amount, "");
    }

    function _generateNFTId(string memory _name, string memory _url) private pure returns (uint) {
        return uint(keccak256(abi.encodePacked(_name, _url)));
    }
}