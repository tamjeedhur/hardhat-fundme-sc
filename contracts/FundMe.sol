// SPDX-License-Identifier:MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

error FundMe__NotOwner();

/**
 * @title A contract for crowd funding
 * @author Tamjeed hur
 * @notice this is contract to demo a sample contract
 * @dev this implements price feeds as our library
 */


contract FundMe {

    
    using PriceConverter for uint256;

    event Funded(address indexed from, uint256 amount);

    uint256 public constant minimumUsd = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public funderWithAmount;
    address public immutable owner;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function Fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= minimumUsd,
            "Didn't send enough ethers !!!"
        );
        funders.push(msg.sender);
        funderWithAmount[msg.sender] = msg.value.getConversionRate(priceFeed);
    }

    function Withdraw() public onlyAdmin {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            funderWithAmount[funder] = 0;
        }

        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed!");
    }

    modifier onlyAdmin() {
        // require(msg.sender == owner, "You are not Owner!");
        if (msg.sender != owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    receive() external payable {
        Fund();
    }

    fallback() external payable {
        Fund();
    }
}
