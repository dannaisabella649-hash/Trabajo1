-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-03-2026 a las 17:37:40
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `libreria`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_contacto_socio` (IN `p_numero` INT, IN `p_direccion` VARCHAR(255), IN `p_telefono` VARCHAR(10))   BEGIN
    UPDATE socio
    SET 
        SOC_DIRECCION = p_direccion,
        SOC_TELEFONO = p_telefono
    WHERE SOC_NUMERO = p_numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_libro_por_nombre` (IN `p_nombre` VARCHAR(255))   BEGIN
    SELECT 
        LIB_ISBN,
        LIB_TITULO,
        LIB_GENERO,
        LIB_NUMERO_PAGINAS,
        LIB_DIAS_PRESTADO
    FROM libro
    WHERE LIB_TITULO LIKE CONCAT('%', p_nombre, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_socio_apellido` (IN `p_apellido` VARCHAR(45))   BEGIN
    SELECT 
        SOC_NUMERO,
        SOC_NOMBRE,
        SOC_APELLIDO,
        SOC_DIRECCION,
        SOC_TELEFONO
    FROM socio
    WHERE SOC_APELLIDO LIKE CONCAT('%', p_apellido, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_libros_en_prestamo` ()   BEGIN
    SELECT 
        l.LIB_ISBN,
        l.LIB_TITULO,
        p.PRES_ID,
        p.PRES_FECHA_PRESTAMO,
        s.SOC_NUMERO,
        s.SOC_NOMBRE,
        s.SOC_APELLIDO
    FROM prestamo p
    INNER JOIN libro l
        ON p.LIB_COPIA_ISBN = l.LIB_ISBN
    INNER JOIN socio s
        ON p.SOC_COPIA_NUMERO = s.SOC_NUMERO
    ORDER BY p.PRES_FECHA_PRESTAMO DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaAutores` ()   BEGIN
    SELECT AUT_CODIGO, AUT_APELLIDO
    FROM autor
    ORDER BY AUT_APELLIDO DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_socios_prestamos` ()   BEGIN
    SELECT 
        s.SOC_NUMERO,
        s.SOC_NOMBRE,
        s.SOC_APELLIDO,
        p.PRES_ID,
        p.PRES_FECHA_PRESTAMO,
        p.PRES_FECHA_DEVOLUCION
    FROM socio s
    LEFT JOIN prestamo p
        ON s.SOC_NUMERO = p.SOC_COPIA_NUMERO
    ORDER BY s.SOC_APELLIDO ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoAutor` (IN `variable` VARCHAR(20))   BEGIN
    SELECT 
        a.AUT_APELLIDO AS 'Autor',
        t.TIPO_AUTOR
    FROM autor a
    INNER JOIN tipo_autores t
        ON a.AUT_CODIGO = t.COPIA_AUTOR
    WHERE t.TIPO_AUTOR = variable;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_libro` (IN `c1_isbn` BIGINT, IN `c2_titulo` VARCHAR(255), IN `c3_genero` VARCHAR(20), IN `c4_paginas` INT, IN `c5diaspres` TINYINT)   BEGIN
    INSERT INTO libro(
        LIB_ISBN,
        LIB_TITULO,
        LIB_GENERO,
        LIB_NUMERO_PAGINAS,
        LIB_DIAS_PRESTADO
    )
    VALUES (c1_isbn, c2_titulo, c3_genero, c4_paginas, c5diaspres);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_socio` (IN `p_numero` INT, IN `p_nombre` VARCHAR(25), IN `p_apellido` VARCHAR(45), IN `p_direccion` VARCHAR(255), IN `p_telefono` VARCHAR(10))   BEGIN
    INSERT INTO socio (
        SOC_NUMERO,
        SOC_NOMBRE,
        SOC_APELLIDO,
        SOC_DIRECCION,
        SOC_TELEFONO
    )
    VALUES (
        p_numero,
        p_nombre,
        p_apellido,
        p_direccion,
        p_telefono
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mostrar_libros` ()   BEGIN
    SELECT 
        LIB_ISBN,
        LIB_TITULO,
        LIB_GENERO,
        LIB_NUMERO_PAGINAS,
        LIB_DIAS_PRESTADO
    FROM libro;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `contar_socios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM socio;

    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `dias_prestamo` (`p_isbn` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE dias INT;

    SELECT DATEDIFF(PRES_FECHA_DEVOLUCION, PRES_FECHA_PRESTAMO)
    INTO dias
    FROM prestamo
    WHERE LIB_COPIA_ISBN = p_isbn
    LIMIT 1;

    RETURN dias;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(11) NOT NULL,
  `socNumero_audi` int(11) DEFAULT NULL,
  `socNombre_anterior` varchar(45) DEFAULT NULL,
  `socApellido_anterior` varchar(45) DEFAULT NULL,
  `socDireccion_anterior` varchar(255) DEFAULT NULL,
  `socTelefono_anterior` varchar(25) DEFAULT NULL,
  `socNombre_nuevo` varchar(45) DEFAULT NULL,
  `socApellido_nuevo` varchar(45) DEFAULT NULL,
  `socDireccion_nuevo` varchar(255) DEFAULT NULL,
  `socTelefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(40) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `AUT_CODIGO` int(11) NOT NULL,
  `AUT_APELLIDO` varchar(45) NOT NULL,
  `AUT_NACIMIENTO` date NOT NULL,
  `AUT_MUERTE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`AUT_CODIGO`, `AUT_APELLIDO`, `AUT_NACIMIENTO`, `AUT_MUERTE`) VALUES
(98, 'Smith', '1974-12-21', '2018-07-21'),
(123, 'Taylor', '1980-04-15', NULL),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', NULL),
(432, 'Miller', '1981-10-26', NULL),
(456, 'García', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', NULL),
(765, 'López', '1976-07-08', '2000-05-10'),
(789, 'Rodríguez', '1985-12-10', NULL),
(890, 'Brown', '1982-11-17', NULL),
(901, 'Soto', '1979-05-13', '2015-11-05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `LIB_ISBN` bigint(20) NOT NULL,
  `LIB_TITULO` varchar(255) NOT NULL,
  `LIB_GENERO` varchar(20) NOT NULL,
  `LIB_NUMERO_PAGINAS` int(11) NOT NULL,
  `LIB_DIAS_PRESTADO` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`LIB_ISBN`, `LIB_TITULO`, `LIB_GENERO`, `LIB_NUMERO_PAGINAS`, `LIB_DIAS_PRESTADO`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodia de la Oscuridad', 'romance', 189, 7),
(2718281828, 'El Bosque de los Suspiros', 'novela', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7),
(9788426721006, 'sql', 'ingenieria', 384, 15);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `libro_after_delete` AFTER DELETE ON `libro` FOR EACH ROW BEGIN
INSERT INTO audi_libro(
lib_isbn,
lib_titulo_anterior,
lib_genero_anterior,
lib_paginas_anterior,
lib_dias_anterior,
audi_fecha,
audi_usuario,
audi_accion
)
VALUES(
OLD.LIB_ISBN,
OLD.LIB_TITULO,
OLD.LIB_GENERO,
OLD.LIB_NUMERO_PAGINAS,
OLD.LIB_DIAS_PRESTADO,
NOW(),
CURRENT_USER(),
'DELETE'
);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_after_insert` AFTER INSERT ON `libro` FOR EACH ROW BEGIN
INSERT INTO audi_libro(
lib_isbn,
lib_titulo_nuevo,
lib_genero_nuevo,
lib_paginas_nuevo,
lib_dias_nuevo,
audi_fecha,
audi_usuario,
audi_accion
)
VALUES(
NEW.LIB_ISBN,
NEW.LIB_TITULO,
NEW.LIB_GENERO,
NEW.LIB_NUMERO_PAGINAS,
NEW.LIB_DIAS_PRESTADO,
NOW(),
CURRENT_USER(),
'INSERT'
);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_before_update` BEFORE UPDATE ON `libro` FOR EACH ROW BEGIN
INSERT INTO audi_libro(
lib_isbn,
lib_titulo_anterior,
lib_genero_anterior,
lib_paginas_anterior,
lib_dias_anterior,
lib_titulo_nuevo,
lib_genero_nuevo,
lib_paginas_nuevo,
lib_dias_nuevo,
audi_fecha,
audi_usuario,
audi_accion
)
VALUES(
OLD.LIB_ISBN,
OLD.LIB_TITULO,
OLD.LIB_GENERO,
OLD.LIB_NUMERO_PAGINAS,
OLD.LIB_DIAS_PRESTADO,
NEW.LIB_TITULO,
NEW.LIB_GENERO,
NEW.LIB_NUMERO_PAGINAS,
NEW.LIB_DIAS_PRESTADO,
NOW(),
CURRENT_USER(),
'UPDATE'
);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `PRES_ID` varchar(20) NOT NULL,
  `PRES_FECHA_PRESTAMO` date NOT NULL,
  `PRES_FECHA_DEVOLUCION` date NOT NULL,
  `SOC_COPIA_NUMERO` int(11) DEFAULT NULL,
  `LIB_COPIA_ISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`PRES_ID`, `PRES_FECHA_PRESTAMO`, `PRES_FECHA_DEVOLUCION`, `SOC_COPIA_NUMERO`, `LIB_COPIA_ISBN`) VALUES
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `SOC_NUMERO` int(11) NOT NULL,
  `SOC_NOMBRE` varchar(25) DEFAULT NULL,
  `SOC_APELLIDO` varchar(45) NOT NULL,
  `SOC_DIRECCION` varchar(255) NOT NULL,
  `SOC_TELEFONO` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`SOC_NUMERO`, `SOC_NOMBRE`, `SOC_APELLIDO`, `SOC_DIRECCION`, `SOC_TELEFONO`) VALUES
(1, 'Ana', 'Ruiz', 'Calle Primavera 123, Ciudad Jardín, Barcelona', '9123456780'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `socios_after_delete` AFTER DELETE ON `socio` FOR EACH ROW BEGIN
INSERT INTO audi_socio(
    socNumero_audi,
    socNombre_anterior,
    socApellido_anterior,
    socDireccion_anterior,
    socTelefono_anterior,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion
)
VALUES(
    OLD.SOC_NUMERO,
    OLD.SOC_NOMBRE,
    OLD.SOC_APELLIDO,
    OLD.SOC_DIRECCION,
    OLD.SOC_TELEFONO,
    NOW(),
    CURRENT_USER(),
    'Registro eliminado'
);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_after_insert` AFTER INSERT ON `socio` FOR EACH ROW BEGIN
INSERT INTO audi_socio(
    socNumero_audi,
    socNombre_nuevo,
    socApellido_nuevo,
    socDireccion_nuevo,
    socTelefono_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion
)
VALUES(
    NEW.SOC_NUMERO,
    NEW.SOC_NOMBRE,
    NEW.SOC_APELLIDO,
    NEW.SOC_DIRECCION,
    NEW.SOC_TELEFONO,
    NOW(),
    CURRENT_USER(),
    'Registro insertado'
);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `socio` FOR EACH ROW BEGIN
INSERT INTO audi_socio(
    socNumero_audi,
    socNombre_anterior,
    socApellido_anterior,
    socDireccion_anterior,
    socTelefono_anterior,
    socNombre_nuevo,
    socApellido_nuevo,
    socDireccion_nuevo,
    socTelefono_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion
)
VALUES(
    NEW.SOC_NUMERO,
    OLD.SOC_NOMBRE,
    OLD.SOC_APELLIDO,
    OLD.SOC_DIRECCION,
    OLD.SOC_TELEFONO,
    NEW.SOC_NOMBRE,
    NEW.SOC_APELLIDO,
    NEW.SOC_DIRECCION,
    NEW.SOC_TELEFONO,
    NOW(),
    CURRENT_USER(),
    'Actualización'
);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_telefono_socio` BEFORE INSERT ON `socio` FOR EACH ROW BEGIN
DECLARE existe INT;

SELECT COUNT(*) INTO existe
FROM socio
WHERE SOC_TELEFONO = NEW.SOC_TELEFONO;

IF existe > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El telefono ya esta registrado para otro socio';
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_autores`
--

CREATE TABLE `tipo_autores` (
  `COPIA_ISBN` bigint(20) DEFAULT NULL,
  `COPIA_AUTOR` int(11) DEFAULT NULL,
  `TIPO_AUTOR` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_autores`
--

INSERT INTO `tipo_autores` (`COPIA_ISBN`, `COPIA_AUTOR`, `TIPO_AUTOR`) VALUES
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(2718281828, 789, 'Traductor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`AUT_CODIGO`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`LIB_ISBN`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`PRES_ID`),
  ADD KEY `SOC_COPIA_NUMERO` (`SOC_COPIA_NUMERO`),
  ADD KEY `LIB_COPIA_ISBN` (`LIB_COPIA_ISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`SOC_NUMERO`);

--
-- Indices de la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD KEY `COPIA_ISBN` (`COPIA_ISBN`),
  ADD KEY `COPIA_AUTOR` (`COPIA_AUTOR`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`SOC_COPIA_NUMERO`) REFERENCES `socio` (`SOC_NUMERO`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`LIB_COPIA_ISBN`) REFERENCES `libro` (`LIB_ISBN`);

--
-- Filtros para la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD CONSTRAINT `tipo_autores_ibfk_1` FOREIGN KEY (`COPIA_ISBN`) REFERENCES `libro` (`LIB_ISBN`),
  ADD CONSTRAINT `tipo_autores_ibfk_2` FOREIGN KEY (`COPIA_AUTOR`) REFERENCES `autor` (`AUT_CODIGO`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
