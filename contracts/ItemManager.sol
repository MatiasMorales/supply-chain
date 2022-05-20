// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.1;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    enum ItemState {
        Created,
        Paid,
        Delivered
    }

    struct S_Item {
        Item item;
        string id;
        uint256 price;
        ItemState state;
    }

    mapping(uint256 => S_Item) public items;

    uint256 itemIndex;

    event SupplyChainStep(uint256 index, uint256 state, address itemAddress);

    function createItem(string memory _id, uint256 _price) public onlyOwner {
        Item item = new Item(itemIndex, _price, this);
        items[itemIndex].item = item;
        items[itemIndex].id = _id;
        items[itemIndex].price = _price;
        items[itemIndex].state = ItemState.Created;

        emit SupplyChainStep(
            itemIndex,
            uint256(items[itemIndex].state),
            address(item)
        );
        itemIndex++;
    }

    function triggerPayment(uint256 _index) public payable {
        require(
            items[_index].price == msg.value,
            "Only full payments accepted."
        );
        require(
            items[_index].state == ItemState.Created,
            "Item is futher in the supply chain."
        );

        items[_index].state = ItemState.Paid;
        emit SupplyChainStep(
            _index,
            uint256(items[_index].state),
            address(items[_index].item)
        );
    }

    function triggerDelivery(uint256 _index) public onlyOwner {
        require(
            items[_index].state == ItemState.Paid,
            "Item is futher in the supply chain."
        );

        items[_index].state = ItemState.Delivered;
        emit SupplyChainStep(
            _index,
            uint256(items[_index].state),
            address(items[_index].item)
        );
    }
}
