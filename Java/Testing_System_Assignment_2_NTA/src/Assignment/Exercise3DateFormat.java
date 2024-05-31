package Assignment;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import Assignment.Position.PositionName;

public class Exercise3DateFormat {
	public static void main(String[] args) {
		// Create Department
		Department dep1 = new Department();
		dep1.id = 1;
		dep1.name = "Marketing";
		
		Department dep2 = new Department();
		dep2.id = 2;
		dep2.name = "Sale";
		
		Department dep3 = new Department();
		dep3.id = 3;
		dep3.name = "BOD";
		
		// Create Position
		Position pos1 = new Position();
		pos1.id = 1;
		pos1.name = PositionName.Dev;
		
		Position pos2 = new Position();
		pos2.id = 2;
		pos2.name = PositionName.PM;
		
		Position pos3 = new Position();
		pos3.id = 3;
		pos3.name = PositionName.Scrum_Master;
		
		// Create Group
		
		Group group1 = new Group();
		group1.id = 1;
		group1.name = "Testing System";
		group1.createDate = LocalDate.of(2023, 1, 1);
		
		Group group2 = new Group();
		group2.id = 2;
		group2.name = "Dev";
		group2.createDate = LocalDate.of(2023, 2, 1);
		
		Group group3 = new Group();
		group3.id = 3;
		group3.name = "Sale";
		group3.createDate = LocalDate.of(2022, 9, 23);
		
		// Create Account
		Account acc1= new Account();
		acc1.id = 1;
		acc1.email = "daonq1";
		acc1.userName = "daonq1";
		acc1.fullName = "Dao Nguyen 1";
		acc1.department = dep1;
		acc1.position = pos1;
		acc1.createDate = LocalDate.now();
		Group[] groupAcc1 = { group1, group2 };
		acc1.groups = groupAcc1;
		
		Account acc2 = new Account();
		acc2.id = 2;
		acc2.email = "daonq2";
		acc2.userName = "daonq2";
		acc2.fullName = "Dao Nguyen 2";
		acc2.department = dep2;
		acc2.position = pos2;
		acc2.createDate = LocalDate.of(2023,02,17);
		Group[] groupAcc2 = { group3, group2};
		acc2.groups = groupAcc2;
		
		Account acc3 = new Account();
		acc3.id = 3;
		acc3.email = "daonq3";
		acc3.userName = "daonq3";
		acc3.fullName = "Dao Nguyen 3";
		acc3.department = dep3;
		acc3.position = pos3;
		acc3.createDate = LocalDate.now();
		
		// Group Account 
		group1.accounts = new Account[] { acc1 };
		group2.accounts = new Account[] { acc1, acc2 };
		group3.accounts = new Account[] { acc2 };
		
		// Question 1:
        final DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMMM YYYY", Locale.ENGLISH);
        String output = dtf.format(acc3.createDate);
        System.out.println(output);
	}
}
