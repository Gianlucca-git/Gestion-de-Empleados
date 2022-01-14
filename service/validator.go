package service

import (
	"Cidenet/model/Request_Response"
	"time"
)

type CidenetValidator interface {
	EmployeesRequest(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors)
	Employees(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors)
}

func NewCidenetValidator() CidenetValidator {
	return &cidenetValidator{
		Utilities: NewUtil(),
	}
}

type cidenetValidator struct {
	Utilities
}

//EmployeesRequest validate that the required fields arrive
func (v *cidenetValidator) EmployeesRequest(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors) {
	var newErrors ValidationErrors
	var existError bool

	if len(employee.Name) == 0 {
		newErrors.Name = Required
		existError = true
	}
	if len(employee.LastName) == 0 {
		newErrors.Name = Required
		existError = true
	}
	if len(employee.SecondLastName) == 0 {
		newErrors.SecondLastName = Required
		existError = true
	}
	if employee.Countries == 0 {
		newErrors.Countries = Required
		existError = true
	}
	if employee.IdentificationType == 0 {
		newErrors.IdentificationType = Required
		existError = true
	}
	if len(employee.IdentificationNumber) == 0 {
		newErrors.IdentificationNumber = Required
		existError = true
	}
	if len(employee.Admission) == 0 {
		newErrors.Admission = Required
		existError = true
	}
	if len(employee.RegistrationDate) == 0 {
		newErrors.RegistrationDate = Required
		existError = true
	}
	if len(employee.RegistrationHours) == 0 {
		newErrors.RegistrationHours = Required
		existError = true
	}

	return existError, &newErrors
}

//Employees validate that the fields are in the correct format
func (v *cidenetValidator) Employees(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors) {
	var newErrors ValidationErrors
	var existError bool

	if ok := v.Utilities.RegularExpression(employee.Name, "upper"); len(employee.Name) > 20 || !ok {
		newErrors.Name = Format
		existError = true
	}

	if ok := v.Utilities.RegularExpression(employee.LastName, "upper&space"); len(employee.LastName) > 20 || !ok {
		newErrors.LastName = Format
		existError = true
	}

	if ok := v.Utilities.RegularExpression(employee.SecondLastName, "upper&space"); len(employee.SecondLastName) > 20 || !ok {
		newErrors.SecondLastName = Format
		existError = true
	}

	if len(employee.OthersNames) > 0 {
		if ok := v.Utilities.RegularExpression(employee.OthersNames, "upper&space"); len(employee.OthersNames) > 50 || !ok {
			newErrors.OthersNames = Format
			existError = true
		}
	}

	if ok := v.Utilities.RegularExpression(employee.IdentificationNumber, "document"); len(employee.IdentificationNumber) > 20 || !ok {
		newErrors.IdentificationNumber = Format
		existError = true
	}

	// validate dates
	if ok := v.Utilities.RegularExpression(employee.Admission, "yyyy-mm-dd"); !ok {
		newErrors.Admission = Format
		existError = true
	} else {

		timeInput, err := time.Parse(yyyy_mm_dd, employee.Admission)
		if err != nil {
			panic(err)
		}
		if timeInput.After(time.Now()) {
			newErrors.Admission = UnderflowDate
			existError = true
		} else if timeInput.Before(time.Now().Add(30 * 24 * time.Hour * -1)) {
			newErrors.Admission = OverflowDate
			existError = true
		}

	}

	if ok := v.Utilities.RegularExpression(employee.RegistrationDate, "yyyy-mm-dd"); !ok {
		newErrors.RegistrationDate = Format
		existError = true
	} else {

		timeInput, err := time.Parse(yyyy_mm_dd, employee.RegistrationDate)
		if err != nil {
			panic(err)
		}
		if timeInput.After(time.Now()) {
			newErrors.RegistrationDate = UnderflowDate
			existError = true
		}
	}

	if ok := v.Utilities.RegularExpression(employee.RegistrationHours, "hh:mm"); !ok {
		newErrors.RegistrationHours = Format
		existError = true
	}

	// The registration date cannot be less than the admission date
	timeAdmission, err := time.Parse(yyyy_mm_dd, employee.Admission)
	if err != nil {
		panic(err)
	}
	timeRegistrationDate, err := time.Parse(yyyy_mm_dd, employee.RegistrationDate)
	if err != nil {
		panic(err)
	}
	if timeRegistrationDate.Before(timeAdmission) {
		newErrors.RegistrationDate = RegistrationDate
		existError = true
	}

	return existError, &newErrors
}
