// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/**
 * Смарт-контракт для хранения информации о дипломах. Позволяет владельцам добавлять, проверять и удалять записи дипломов.
 * @author YourName
 */
contract DiplomaRegistry {
    // Переменные состояния
    address public immutable owner;

    struct Diploma {
        string studentName;
        string universityName;
        string degree;
        uint256 graduationYear;
        bool exists;
    }

    // Хранилище дипломов по хэшу (например, хэшу данных диплома или ID)
    mapping(bytes32 => Diploma) private diplomas;

    // События для отслеживания изменений
    event DiplomaAdded(bytes32 indexed diplomaHash, string studentName, string universityName, uint256 graduationYear);
    event DiplomaRemoved(bytes32 indexed diplomaHash);

    // Модификатор для проверки прав владельца
    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    // Конструктор
    constructor() {
        owner = msg.sender;
    }

    /**
     * Функция для добавления нового диплома.
     * @param diplomaHash Хэш данных диплома.
     * @param studentName Имя студента.
     * @param universityName Название университета.
     * @param degree Степень.
     * @param graduationYear Год выпуска.
     */
    function addDiploma(
        bytes32 diplomaHash,
        string memory studentName,
        string memory universityName,
        string memory degree,
        uint256 graduationYear
    ) public isOwner {
        require(!diplomas[diplomaHash].exists, "Diploma already exists");

        diplomas[diplomaHash] = Diploma({
            studentName: studentName,
            universityName: universityName,
            degree: degree,
            graduationYear: graduationYear,
            exists: true
        });

        emit DiplomaAdded(diplomaHash, studentName, universityName, graduationYear);
    }

    /**
     * Функция для проверки диплома.
     * @param diplomaHash Хэш данных диплома.
     * @return Информация о дипломе.
     */
    function verifyDiploma(bytes32 diplomaHash) public view returns (Diploma memory) {
        require(diplomas[diplomaHash].exists, "Diploma does not exist");
        return diplomas[diplomaHash];
    }

    /**
     * Функция для удаления диплома.
     * @param diplomaHash Хэш данных диплома.
     */
    function removeDiploma(bytes32 diplomaHash) public isOwner {
        require(diplomas[diplomaHash].exists, "Diploma does not exist");

        delete diplomas[diplomaHash];
        emit DiplomaRemoved(diplomaHash);
    }
}