// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LibrarySystem {
    address public admin;
    uint public bookCount;

    struct Book {
        uint id;
        string title;
        string author;
        bool isIssued;
        address borrower;
        uint issueDate;
    }

    mapping(uint => Book) public books;

    event BookAdded(uint indexed id, string title, string author);
    event BookIssued(uint indexed id, address indexed borrower);
    event BookReturned(uint indexed id, address indexed borrower);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addBook(string memory _title, string memory _author) public onlyAdmin {
        bookCount++;
        books[bookCount] = Book(bookCount, _title, _author, false, address(0), 0);
        emit BookAdded(bookCount, _title, _author);
    }

    function issueBook(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        require(!books[_id].isIssued, "Book is already issued");
        books[_id].isIssued = true;
        books[_id].borrower = msg.sender;
        books[_id].issueDate = block.timestamp;
        emit BookIssued(_id, msg.sender);
    }

    function returnBook(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        require(books[_id].isIssued, "Book is not currently issued");
        require(books[_id].borrower == msg.sender, "You are not the borrower");
        books[_id].isIssued = false;
        books[_id].borrower = address(0);
        books[_id].issueDate = 0;
        emit BookReturned(_id, msg.sender);
    }

    function getBook(uint _id) public view returns (
        string memory title,
        string memory author,
        bool isIssued,
        address borrower,
        uint issueDate
    ) {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        Book memory b = books[_id];
        return (b.title, b.author, b.isIssued, b.borrower, b.issueDate);
    }
}