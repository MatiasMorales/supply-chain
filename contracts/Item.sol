// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.1;

import "./ItemManager.sol";

contract Item {
    uint256 public index;
    uint256 public pricePaid;
    uint256 public weiPrice;

    ItemManager parentContract;

    constructor(
        uint256 _index,
        uint256 _weiPrice,
        ItemManager _itemManager
    ) public {
        index = _index;
        weiPrice = _weiPrice;
        parentContract = _itemManager;
    }

    receive() external payable {
        require(msg.value == weiPrice, "Partial payments not supported");
        require(pricePaid == 0, "Item is paid already");

        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call.value(msg.value)(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );

        require(success, "The transaction wasn't successful, cancelling.");
    }
}
