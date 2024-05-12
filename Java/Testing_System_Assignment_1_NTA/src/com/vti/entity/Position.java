package com.vti.entity;;

public class Position {
	public int id;
	public PositionName name;
	
	public enum PositionName {
		Dev, Test, Scrum_Master, PM
	}
}
