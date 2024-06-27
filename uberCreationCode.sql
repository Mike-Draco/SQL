-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Uber
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Uber` ;

-- -----------------------------------------------------
-- Schema Uber
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Uber` DEFAULT CHARACTER SET utf8 ;
USE `Uber` ;

-- -----------------------------------------------------
-- Table `Rider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rider` ;

CREATE TABLE IF NOT EXISTS `Rider` (
  `Rider_ID` INT Primary Key,
  `First_Name` VARCHAR(20) NOT NULL COMMENT 'Rider First name with limit of 20 characters',
  `Last_Name` VARCHAR(25) NOT NULL COMMENT 'Rider Last Name with maximum character of 25 ',
  `Phone_Number` varchar(20) NOT NULL,
  `Date_Joined` DATE NULL,
  `Home_Address` VARCHAR(45) NULL,
  `Home_City` VARCHAR(45) NULL,
  `Home_State` CHAR(2) NULL,
  `Home_ZipCode` INT NULL,
  `Email_Address` VARCHAR(45) NULL,
  `Rider_Rating` DECIMAL(3,2) NULL COMMENT 'Aggregated rating over time. No rider will not have data so there does not need to be a no null restriction');

CREATE UNIQUE INDEX `Rider_ID_UNIQUE` ON `Rider` (`Rider_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Driver`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Driver` ;

CREATE TABLE IF NOT EXISTS `Driver` (
  `Driver_ID` INT Primary Key,
  `First_Name` VARCHAR(20) NOT NULL,
  `Last_Name` VARCHAR(25) NOT NULL,
  `Phone_Number` Varchar(20) NOT NULL,
  `Email_Address` VARCHAR(45) NULL,
  `Driver_Rating` DECIMAL(3,2) NULL COMMENT 'Optional bc new driver won\'t have rating');

CREATE UNIQUE INDEX `Driver_ID_UNIQUE` ON `Driver` (`Driver_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trip` ;

CREATE TABLE IF NOT EXISTS `Trip` (
  `Trip_Code` INT Primary Key,
  `Trip_Size` CHAR(2) NOT NULL COMMENT 'Either large or xl',
  `Trip_Price` DECIMAL(6,2) NOT NULL COMMENT 'Make price should not be over thousands',
  `Trip_Tip` DECIMAL(5,2) NULL,
  `Trip_DAddress` VARCHAR(45) NOT NULL,
  `Trip_DCity` VARCHAR(45) NOT NULL,
  `Trip_DState` CHAR(2) NOT NULL,
  `Trip_DZipCode` CHAR(5) NOT NULL,
  `Trip_PickupAddress` VARCHAR(45) NOT NULL,
  `Trip_PCity` VARCHAR(45) NOT NULL,
  `Trip_PState` CHAR(45) NOT NULL,
  `Trip_PZipCode` CHAR(5) NOT NULL,
  `Time_Booked` varchar(15) NOT NULL,
  `Trip_ETA` varchar(15) NOT NULL,
  `Trip_Length` VARCHAR(20) NOT NULL COMMENT '\'00:00:00\' format',
  Rider_ID Int, 
  Driver_ID Int,
  CONSTRAINT `fk_Rider_ID`
    FOREIGN KEY (`Rider_ID`)
    REFERENCES `Rider` (`Rider_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
constraint fk_Driver_ID
	foreign key (Driver_ID)
    references Driver (Driver_ID)
    on delete no action
    on update no action) ;


-- -----------------------------------------------------
-- Table `Review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Review` ;

CREATE TABLE IF NOT EXISTS `Review` (
  `Review_ID` INT Primary Key,
  `Review_byDriver` DECIMAL(3,2) NULL COMMENT 'A rating from 1-5\n',
  `Review_byRider` DECIMAL(3,2) NULL COMMENT 'a rating from 1-5',
  `Comments_byRider` VARCHAR(100) NULL COMMENT 'Rider can provide a short comment about the driver',
  `Trip_Code` INT NOT NULL,
  `Rider_Rider_ID` INT NOT NULL,
  `Driver_ID` INT NOT NULL,
  CONSTRAINT `fk_Review_Trip`
    FOREIGN KEY (`Trip_Code`)
    REFERENCES `Trip` (`Trip_Code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX `Review_ID_UNIQUE` ON `Review` (`Review_ID` ASC) VISIBLE;

CREATE INDEX `fk_Review_Trip_idx` ON `Review` (`Trip_Code` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Verification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Verification` ;

CREATE TABLE IF NOT EXISTS `Verification` (
  `Verification_ID` INT Primary Key,
  `Verification_Date` DATE NULL,
  `Driver_ID` INT NOT NULL,
  CONSTRAINT `fk_Verification_Driver1`
    FOREIGN KEY (`Driver_ID`)
    REFERENCES `Driver` (`Driver_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX `Verification_ID_UNIQUE` ON `Verification` (`Verification_ID` ASC) VISIBLE;

CREATE INDEX `fk_Verification_Driver1_idx` ON `Verification` (`Driver_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Car`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Car` ;

CREATE TABLE IF NOT EXISTS `Car` (
  `Car_ID` INT Primary Key,
  `Car_Make` VARCHAR(45) NOT NULL COMMENT 'Not null bc need information for safety of rider',
  `Car_Model` VARCHAR(45) NOT NULL COMMENT 'Not null for safety of rider ',
  `Car_Size` CHAR(2) NOT NULL COMMENT 'Either size large or xl, not null bc need to know of it can fit group size',
  `License_Plate` VARCHAR(8) NOT NULL COMMENT 'Not null for safety and convenience of rider, max 8 characters for all license plates',
  `Driver_ID` INT NOT NULL,
  CONSTRAINT `fk_Car_Driver1`
    FOREIGN KEY (`Driver_ID`)
    REFERENCES `Driver` (`Driver_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX `Car_ID_UNIQUE` ON `Car` (`Car_ID` ASC) VISIBLE;

CREATE INDEX `fk_Car_Driver1_idx` ON `Car` (`Driver_ID` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


