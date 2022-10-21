// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract MedicalRecord {
    uint public timeAvailable;
    address public owner;
    mapping(address=> Doctor) public doctors;
    mapping(address=> Patient) private patients;

    struct Visit {
        Doctor doctor;
        Patient patient;
        uint startVisit;
        string sintoms;
        string diagnosis;
        string treatment;
        string observations;
    }

    struct Doctor {
        address doctor_address; 
        string college_number;
        string name;
        string specialty;
        address patient_address;
        // Maybe Hospital?
    }

    struct Patient {
        address patient_address;
        address doctor_address;
        uint time_of_visit;
        string phone_number;
        string id;
        string name;
        int bornDate;
        Visit[] visits;
    }

    event RequireMedicalRecord(Doctor doctor, string patient_id);

    constructor() payable {
        timeAvailable = 1 hours;
        owner = msg.sender;
    }

    function createDoctor(address _doctor_address, string calldata _college_number, string calldata _name, string calldata _speciality) public {
        require(msg.sender == owner, "Only owner can create doctor");
        doctors[_doctor_address] = Doctor({
            doctor_address: _doctor_address,
            college_number: _college_number,
            name: _name,
            specialty: _speciality,
            patient_address: address(0)
        });
    }

    function createpatient(string calldata _phone_number, string calldata _id, string calldata _name, int _bornDate) public {
        require (patients[msg.sender].patient_address == address(0));
        patients[msg.sender] = Patient({
            patient_address: msg.sender,
            doctor_address: address(0),
            time_of_visit: 0,
            phone_number: _phone_number,
            id: _id,
            name: _name,
            bornDate: _bornDate,
            visits: new Visit[](0)
        });
    }

    function createEntry(address _patient_id, string calldata _sintoms, string calldata _diagnosis, string calldata _treatment, string calldata _observations) public {
        require(doctors[msg.sender].doctor_address != address(0), "Only doctors can create entries");
        require(patients[_patient_id].patient_address != address(0), "patient does not exist");
        require(patients[_patient_id].doctor_address == msg.sender, "You are not the doctor of this patient");
        patients[_patient_id].doctor_address = address(0);
        patients[_patient_id].visits.push(Visit({
            doctor: doctors[msg.sender],
            patient: patients[_patient_id],
            startVisit: block.timestamp,
            sintoms: _sintoms,
            diagnosis: _diagnosis,
            treatment: _treatment,
            observations: _observations
        }));
    }
}
