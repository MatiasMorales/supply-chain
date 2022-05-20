var assert = require('assert');

const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("should be able to add an item", async function(){
        const itemManagerInstace = await ItemManager.deployed();
        const id = "item1";
        const price = 100;
        const result = await itemManagerInstace.createItem(id, price, {from: accounts[0]});

        assert.equal(result.logs[0].args.index, 0, "This is not the first item");

        const item = await itemManagerInstace.items(0);

        assert.equal(item.id, id, "Item identifier was different");
    })
});
