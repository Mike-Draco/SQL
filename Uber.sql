-- MySQL Script generated by MySQL Workbench
-- Thu Apr 16 00:01:23 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Car`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Car` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Car` (
  `Car_ID` INT GENERATED ALWAYS AS () VIRTUAL COMMENT 'Autogenerated per driver car',
  `Car_Make` VARCHAR(45) NOT NULL COMMENT 'Not null bc need information for safety of rider',
  `Car_Model` VARCHAR(45) NOT NULL COMMENT 'Not null for safety of rider ',
  `Car_Size` CHAR(2) NOT NULL COMMENT 'Either size large or xl, not null bc need to know of it can fit group size',
  `License_Plate` VARCHAR(8) NOT NULL COMMENT 'Not null for safety and convenience of rider, max 8 characters for all license plates',
  `Driver_ID` INT NOT NULL,
  PRIMARY KEY (`Car_ID`, `Driver_ID`),
  UNIQUE INDEX `Car_ID_UNIQUE` (`Car_ID` ASC) VISIBLE,
  INDEX `fk_Car_Driver1_idx` (`Driver_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Car_Driver1`
    FOREIGN KEY (`Driver_ID`)
    REFERENCES `mydb`.`Driver` (`Driver_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Driver`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Driver` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Driver` (
  `Driver_ID` INT GENERATED ALWAYS AS () VIRTUAL,
  `First_Name` VARCHAR(20) NOT NULL,
  `Last_Name` VARCHAR(25) NOT NULL,
  `Phone_Number` INT(7) NOT NULL,
  `Email_Address` VARCHAR(45) NULL,
  `Driver_Rating` DECIMAL(3,2) NULL COMMENT 'Optional bc new driver won\'t have rating',
  PRIMARY KEY (`Driver_ID`),
  UNIQUE INDEX `Driver_ID_UNIQUE` (`Driver_ID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Review` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Review` (
  `Review_ID` INT GENERATED ALWAYS AS () VIRTUAL COMMENT 'generated IDs by ride',
  `Review_byDriver` DECIMAL(3,2) NULL COMMENT 'A rating from 1-5\n',
  `Review_byRider` DECIMAL(3,2) NULL COMMENT 'a rating from 1-5',
  `Comments_byRider` VARCHAR(100) NULL COMMENT 'Rider can provide a short comment about the driver',
  `Trip_Code` INT NOT NULL,
  `Rider_Rider_ID` INT NOT NULL,
  `Driver_ID` INT NOT NULL,
  PRIMARY KEY (`Review_ID`),
  UNIQUE INDEX `Review_ID_UNIQUE` (`Review_ID` ASC) VISIBLE,
  INDEX `fk_Review_Trip_idx` (`Trip_Code` ASC) VISIBLE,
  CONSTRAINT `fk_Review_Trip`
    FOREIGN KEY (`Trip_Code`)
    REFERENCES `mydb`.`Trip` (`Trip_Code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Rider` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Rider` (
  `Rider_ID` INT GENERATED ALWAYS AS () VIRTUAL COMMENT 'Autogenerated for each rider',
  `First_Name` VARCHAR(20) NOT NULL COMMENT 'Rider First name with limit of 20 characters',
  `Last_Name` VARCHAR(25) NOT NULL COMMENT 'Rider Last Name with maximum character of 25 ',
  `Phone_Number` INT(7) NOT NULL,
  `Date_Joined` DATE NULL,
  `Home_Address` VARCHAR(45) NULL,
  `Home_City` VARCHAR(45) NULL,
  `Home_State` CHAR(2) NULL,
  `Home_ZipCode` INT(5) NULL,
  `Email_Address` VARCHAR(45) NULL,
  `Rider_Rating` DECIMAL(3,2) NULL COMMENT 'Aggregated rating over time. No rider will not have data so there does not need to be a no null restriction',
  PRIMARY KEY (`Rider_ID`),
  UNIQUE INDEX `Rider_ID_UNIQUE` (`Rider_ID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Trip` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Trip` (
  `Trip_Code` INT GENERATED ALWAYS AS () VIRTUAL,
  `Trip_Size` CHAR(2) BINARY NOT NULL COMMENT 'Either large or xl',
  `Trip_Price` DECIMAL(6,2) NOT NULL COMMENT 'Make price should not be over thousands',
  `Trip_Tip` DECIMAL(5,2) NULL,
  `Trip_DAddress` VARCHAR(45) NOT NULL,
  `Trip_DCity` VARCHAR(45) NOT NULL,
  `Trip_DState` CHAR(2) NOT NULL,
  `Trip_DZipCode` CHAR(5) NOT NULL,
  `Trip_PickupAddress` VARCHAR(45) NOT NULL,
  `Trip_PCity` VARCHAR(45) NOT NULL,
  `Trip_PState` CHAR(2) NOT NULL,
  `Trip_PZipCode` CHAR(5) NOT NULL,
  `Time_Booked` TIME NOT NULL,
  `Trip_ETA` TIME NOT NULL,
  `Trip_Length` VARCHAR(8) NOT NULL COMMENT '\'00:00:00\' format',
  `Rider_ID` INT NOT NULL,
  `Driver_ID` INT NOT NULL,
  PRIMARY KEY (`Trip_Code`, `Rider_ID`, `Driver_ID`),
  UNIQUE INDEX `Trip_Code_UNIQUE` (`Trip_Code` ASC) VISIBLE,
  INDEX `fk_Trip_Rider1_idx` (`Rider_ID` ASC) VISIBLE,
  INDEX `fk_Trip_Driver1_idx` (`Driver_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Trip_Rider1`
    FOREIGN KEY (`Rider_ID`)
    REFERENCES `mydb`.`Rider` (`Rider_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trip_Driver1`
    FOREIGN KEY (`Driver_ID`)
    REFERENCES `mydb`.`Driver` (`Driver_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Verification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Verification` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Verification` (
  `Verification_ID` INT GENERATED ALWAYS AS () VIRTUAL COMMENT 'Generated Id for drivers',
  `Verification_Date` DATE NULL,
  `Driver_ID` INT NOT NULL,
  PRIMARY KEY (`Verification_ID`, `Driver_ID`),
  UNIQUE INDEX `Verification_ID_UNIQUE` (`Verification_ID` ASC) VISIBLE,
  INDEX `fk_Verification_Driver1_idx` (`Driver_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Verification_Driver1`
    FOREIGN KEY (`Driver_ID`)
    REFERENCES `mydb`.`Driver` (`Driver_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
