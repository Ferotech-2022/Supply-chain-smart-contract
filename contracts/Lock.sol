// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;
    uint public productCount;

    struct Product {
        uint id;
        string name;
        string description;
        address manufacturer;
        address[] supplyChainHistory;
    }

    mapping(uint => Product) public products;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory _name, string memory _description) external onlyOwner {
        productCount++;
        products[productCount] = Product(productCount, _name, _description, msg.sender, new address[](0));
    }

    function getProduct(uint _productId) external view returns (
        uint id,
        string memory name,
        string memory description,
        address manufacturer,
        address[] memory supplyChainHistory
    ) {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        Product memory product = products[_productId];
        return (
            product.id,
            product.name,
            product.description,
            product.manufacturer,
            product.supplyChainHistory
        );
    }

    function addToSupplyChain(uint _productId) external {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        Product storage product = products[_productId];
        require(msg.sender == product.manufacturer, "Only the manufacturer can add to the supply chain");

        // Add the current user to the supply chain history
        product.supplyChainHistory.push(msg.sender);
    }
}
