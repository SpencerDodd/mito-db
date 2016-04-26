-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema BucketList
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BucketList
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BucketList` DEFAULT CHARACTER SET latin1 ;
USE `BucketList` ;

-- -----------------------------------------------------
-- Table `BucketList`.`tbl_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BucketList`.`tbl_user` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NULL DEFAULT NULL,
  `user_username` VARCHAR(45) NULL DEFAULT NULL,
  `user_password` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `BucketList` ;

-- -----------------------------------------------------
-- procedure sp_createUser
-- -----------------------------------------------------

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser`(
	IN p_name VARCHAR(45),
  IN p_username VARCHAR(45),
  IN p_password VARCHAR(45)
)
BEGIN
	if ( select exists (select 1 from tbl_user where user_username = p_username) ) THEN
     
        select 'Username Exists !!';
     
    ELSE
     
        insert into tbl_user
        (
            user_name,
            user_username,
            user_password
        )
        values
        (
            p_name,
            p_username,
            p_password
        );
     
    END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
