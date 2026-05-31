WITH RECURSIVE descendant_tree AS (
	SELECT EmployeeID AS root_id, EmployeeID AS emp_id
	FROM Employees

	UNION ALL

	SELECT dt.root_id, e.EmployeeID
	FROM descendant_tree AS dt
	INNER JOIN Employees AS e ON e.ManagerID = dt.emp_id
	WHERE e.EmployeeID <> dt.emp_id
),
subordinate_counts AS (
	SELECT root_id, COUNT(*) - 1 AS TotalSubordinates
	FROM descendant_tree
	GROUP BY root_id
),
employee_details AS (
	SELECT
		e.EmployeeID,
		e.Name AS EmployeeName,
		e.ManagerID,
		d.DepartmentName,
		r.RoleName,
		STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,
		STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
	FROM Employees AS e
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
)
SELECT
	ed.EmployeeID,
	ed.EmployeeName,
	ed.ManagerID,
	ed.DepartmentName,
	ed.RoleName,
	ed.ProjectNames,
	ed.TaskNames,
	sc.TotalSubordinates
FROM employee_details AS ed
INNER JOIN subordinate_counts AS sc ON sc.root_id = ed.EmployeeID
WHERE ed.RoleName = 'Менеджер'
	AND sc.TotalSubordinates > 0
ORDER BY ed.EmployeeName;
