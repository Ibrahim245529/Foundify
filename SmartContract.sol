// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Foundify
 * @notice Lost and found reporting for FAST-NUCES Islamabad Campus.
 * @dev Deploy to Ethereum Sepolia for the MG3012 mini-dApp assignment.
 *      A wallet address is not proof that someone owns an item.
 */
contract Foundify {
    enum ReportType { Lost, Found }
    enum Status { Open, ClaimPending, Resolved }

    struct Item {
        uint256 id;
        address reporter;
        address claimant;
        ReportType reportType;
        Status status;
        string name;
        string category;
        string location;
        string description;
        uint256 approximateDate; // UTC midnight, seconds since Unix epoch
        string handoverSpot;
        uint256 createdAt;
    }

    uint256 private itemCount;
    mapping(uint256 => Item) private items;

    event ItemReported(uint256 indexed itemId, address indexed reporter, ReportType reportType);
    event ClaimRequested(uint256 indexed itemId, address indexed claimant);
    event ClaimReviewed(uint256 indexed itemId, address indexed claimant, bool returned);

    // 1/5: WRITE - create a lost or found report.
    function reportItem(
        ReportType reportType,
        string memory name,
        string memory category,
        string memory location,
        string memory description,
        uint256 approximateDate,
        string memory handoverSpot
    ) external {
        require(bytes(name).length > 0 && bytes(name).length <= 80, "Invalid item name");
        require(bytes(category).length > 0 && bytes(category).length <= 60, "Invalid category");
        require(bytes(location).length > 0 && bytes(location).length <= 80, "Invalid location");
        require(bytes(description).length > 0 && bytes(description).length <= 500, "Invalid description");
        require(bytes(handoverSpot).length > 0 && bytes(handoverSpot).length <= 80, "Invalid handover spot");
        require(approximateDate > 0 && approximateDate <= block.timestamp, "Invalid date");

        itemCount += 1;
        Item storage item = items[itemCount];
        item.id = itemCount;
        item.reporter = msg.sender;
        item.reportType = reportType;
        item.status = Status.Open;
        item.name = name;
        item.category = category;
        item.location = location;
        item.description = description;
        item.approximateDate = approximateDate;
        item.handoverSpot = handoverSpot;
        item.createdAt = block.timestamp;

        emit ItemReported(itemCount, msg.sender, reportType);
    }

    // 2/5: READ - read one item and its claim information.
    function getItem(uint256 itemId) external view returns (Item memory) {
        require(itemId > 0 && itemId <= itemCount, "Report does not exist");
        return items[itemId];
    }

    // 3/5: READ - total number of reports (used for lists and statistics).
    function getTotalItems() external view returns (uint256) {
        return itemCount;
    }

    // 4/5: WRITE - request to claim an item (one pending claim at a time).
    function requestClaim(uint256 itemId) external {
        require(itemId > 0 && itemId <= itemCount, "Report does not exist");
        Item storage item = items[itemId];
        require(msg.sender != item.reporter, "Cannot claim your own report");
        require(item.status == Status.Open, "Item is not open for claims");

        item.claimant = msg.sender;
        item.status = Status.ClaimPending;
        emit ClaimRequested(itemId, msg.sender);
    }

    // 5/5: WRITE - only the reporter may reject or confirm a handover.
    // returned=true  -> Resolved; returned=false -> Open (claim cleared).
    function reviewClaim(uint256 itemId, bool returned) external {
        require(itemId > 0 && itemId <= itemCount, "Report does not exist");
        Item storage item = items[itemId];
        require(msg.sender == item.reporter, "Only the reporter can review");
        require(item.status == Status.ClaimPending, "No pending claim");

        address previousClaimant = item.claimant;
        if (returned) {
            item.status = Status.Resolved;
        } else {
            item.claimant = address(0);
            item.status = Status.Open;
        }

        emit ClaimReviewed(itemId, previousClaimant, returned);
    }
}
