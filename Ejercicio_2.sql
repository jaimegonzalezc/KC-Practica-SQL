
CREATE TABLE bootcamps (
    bootcamp_id INT NOT NULL,
    description CHAR(50) NOT NULL,
    name CHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (bootcamp_id)
);

CREATE TABLE students (
    student_id INT NOT NULL,
    name CHAR(50) NOT NULL,
    last_name CHAR(50) NOT NULL,
    email CHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    PRIMARY KEY (student_id)
);

CREATE TABLE teachers (
    teacher_id INT NOT NULL,
    name CHAR(50) NOT NULL,
    last_name CHAR(50) NOT NULL,
    email CHAR(50) NOT NULL,
    specialty CHAR(50) NOT NULL,
    PRIMARY KEY (teacher_id)
);

CREATE TABLE modules (
    module_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    teacher_id INT,
    name CHAR(30),
    description CHAR(100),
    subjects CHAR(100),
    PRIMARY KEY (module_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamps(bootcamp_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE enrollment (
    enrollment_id INT NOT NULL,
    student_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    PRIMARY KEY (enrollment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamps(bootcamp_id)
);

INSERT INTO bootcamps (bootcamp_id, description, name, start_date, end_date) VALUES
(1, 'Full Stack Development', 'CodeMaster Bootcamp', '2024-01-15', '2024-06-15'),
(2, 'Data Science', 'DataGenius Bootcamp', '2024-02-01', '2024-07-01'),
(3, 'Cybersecurity', 'SecureTech Bootcamp', '2024-03-01', '2024-08-01'),
(4, 'AI and Machine Learning', 'AIML Bootcamp', '2024-04-01', '2024-09-01'),
(5, 'Cloud Computing', 'CloudPro Bootcamp', '2024-05-01', '2024-10-01');

INSERT INTO students (student_id, name, last_name, email, birth_date) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@example.com', '1995-05-20'),
(2, 'María', 'García', 'maria.garcia@example.com', '1992-08-15'),
(3, 'Carlos', 'López', 'carlos.lopez@example.com', '1990-12-10'),
(4, 'Ana', 'Martínez', 'ana.martinez@example.com', '1998-03-25'),
(5, 'Luis', 'Hernández', 'luis.hernandez@example.com', '1993-07-30');

INSERT INTO teachers (teacher_id, name, last_name, email, specialty) VALUES
(1, 'Laura', 'Gómez', 'laura.gomez@example.com', 'Full Stack Development'),
(2, 'Pedro', 'Fernández', 'pedro.fernandez@example.com', 'Data Science'),
(3, 'Sofía', 'Ruiz', 'sofia.ruiz@example.com', 'Cybersecurity'),
(4, 'Miguel', 'Torres', 'miguel.torres@example.com', 'AI and Machine Learning'),
(5, 'Elena', 'Sánchez', 'elena.sanchez@example.com', 'Cloud Computing');

INSERT INTO modules (module_id, bootcamp_id, teacher_id, name, description, subjects) VALUES
(1, 1, 1, 'HTML & CSS', 'Introduction to web development', 'HTML, CSS'),
(2, 1, 1, 'JavaScript', 'Advanced JavaScript techniques', 'JavaScript, ES6'),
(3, 2, 2, 'Python for Data Science', 'Data analysis with Python', 'Python, Pandas, NumPy'),
(4, 3, 3, 'Network Security', 'Fundamentals of network security', 'Firewalls, VPNs'),
(5, 4, 4, 'Machine Learning Basics', 'Introduction to machine learning', 'Supervised Learning, Unsupervised Learning');

INSERT INTO enrollment (enrollment_id, student_id, bootcamp_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- Nombre de los estudiantes cursando el bootcamp con ID 1
SELECT s.name, s.last_name, b.name AS bootcamp_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN bootcamps b ON e.bootcamp_id = b.bootcamp_id
WHERE b.bootcamp_id = 1;

-- Listar los módulos y sus respectivos profesores para un bootcamp específico
SELECT m.name AS module_name, t.name AS teacher_name, t.last_name
FROM modules m
JOIN teachers t ON m.teacher_id = t.teacher_id
WHERE m.bootcamp_id = 1;

-- Obtener la información de los bootcamps en los que está inscrito un estudiante específico
SELECT s.name, s.last_name, b.name AS bootcamp_name, b.start_date, b.end_date
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN bootcamps b ON e.bootcamp_id = b.bootcamp_id
WHERE s.student_id = 1;

-- Listar todos los módulos de un bootcamp junto con la descripción y los temas
SELECT m.name AS module_name, m.description, m.subjects
FROM modules m
WHERE m.bootcamp_id = 1;




