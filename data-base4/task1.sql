WITH RECURSIVE subordinates AS (
	SELECT EmployeeID
	FROM Employees
	WHERE EmployeeID = 1

	UNION ALL

	SELECT e.EmployeeID
	FROM Employees AS e
	INNER JOIN subordinates AS s ON e.ManagerID = s.EmployeeID
)
SELECT
	e.EmployeeID,
	e.Name AS EmployeeName,
	e.ManagerID,
	d.DepartmentName,
	r.RoleName,
	STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,
	STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
FROM subordinates AS s
INNER JOIN Employees AS e ON e.EmployeeID = s.EmployeeID
LEFT JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
LEFT JOIN Roles AS r ON r.RoleID = e.RoleID
LEFT JOIN Projects AS p ON p.DepartmentID = e.DepartmentID
LEFT JOIN Tasks AS t ON t.AssignedTo = e.EmployeeID
GROUP BY
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	d.DepartmentName,
	r.RoleName
ORDER BY e.Name;
