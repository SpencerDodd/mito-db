-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mitochondrial_genomics
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mitochondrial_genomics
-- -----------------------------------------------------

################################################################################
################################################################################
######################      DATABASE SCHEMA      ###############################
################################################################################
################################################################################

DROP SCHEMA IF EXISTS `mitochondrial_genomics` ;
CREATE SCHEMA IF NOT EXISTS `mitochondrial_genomics` DEFAULT CHARACTER SET latin1 ;
USE `mitochondrial_genomics` ;

-- -----------------------------------------------------
-- Table `mitochondrial_genomics`.`organisms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mitochondrial_genomics`.`organisms` (
  `organism_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `accession_number` VARCHAR(45) NULL DEFAULT NULL,
  `mito_fasta_sequence` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`organism_id`),
  INDEX `name` (`name`))
  
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `mitochondrial_genomics`.`queries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mitochondrial_genomics`.`queries` (
  `query_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `time` DATETIME NULL DEFAULT NULL,
  `organism` VARCHAR(45) NULL DEFAULT NULL,
  `db` VARCHAR(45) NULL DEFAULT NULL,
  `db_version` VARCHAR(45) NULL DEFAULT NULL,
  `result_data` VARCHAR(45) NULL DEFAULT NULL,
  `result_summary` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`query_id`),
  FOREIGN KEY (`organism`) REFERENCES `organisms` (`name`),
  FOREIGN KEY (`result_summary`) REFERENCES `phylogenetic_distances` (`table_id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `mitochondrial_genomics`.`results`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mitochondrial_genomics`.`results` (
  `results_id` INT(11) NOT NULL AUTO_INCREMENT,
  `query_id` INT(11) NULL DEFAULT NULL,
  `hit_organism` VARCHAR(45) NULL DEFAULT NULL,
  `percent_distance_to_common_ancestor` FLOAT(5,2),
  PRIMARY KEY (`results_id`),
  FOREIGN KEY (`hit_organism`) REFERENCES `organisms` (`name`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `mitochondrial_genomics` ;


-- -----------------------------------------------------
-- Table `mitochondrial_genomics`.`phylogenetic_distances`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mitochondrial_genomics`.`phylogenetic_distances` (
  `table_id` INT(11) NOT NULL AUTO_INCREMENT,
  `subspecies_low` FLOAT(5,2) NULL DEFAULT NULL,
  `subspecies_high` FLOAT(5,2) NULL DEFAULT NULL,
  `species_low` FLOAT(5,2) NULL DEFAULT NULL,
  `species_high` FLOAT(5,2) NULL DEFAULT NULL,
  `genus_low` FLOAT(5,2) NULL DEFAULT NULL,
  `genus_high` FLOAT(5,2) NULL DEFAULT NULL,
  `family_low` FLOAT(5,2) NULL DEFAULT NULL,
  `family_high` FLOAT(5,2) NULL DEFAULT NULL,
  `other_low` FLOAT(5,2) NULL DEFAULT NULL,
  `other_high` FLOAT(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`table_id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

################################################################################
################################################################################
######################        PROCEDURES         ###############################
################################################################################
################################################################################

# --------------------------------------------------------------------
# PROCEDURE TO ADD AN ORGANISM TO THE DATABASE WITH THE GIVEN DATA FOR
# EACH FIELD IF AN ORGANISM OF THE GIVEN NAME DOESN'T ALREADY EXIST
# --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `add_organism`;
DELIMITER $$
USE `mitochondrial_genomics`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_organism`(
	IN p_name VARCHAR(45),
    IN p_accession VARCHAR(45),
    IN p_fasta VARCHAR(45)
)
BEGIN
	IF (SELECT exists (SELECT 1 from organisms WHERE organisms.name = p_name) ) THEN
		
        SELECT 'Organism already exists';
	
    ELSE
    
		INSERT INTO organisms
        (
			name,
      accession_number,
      mito_fasta_sequence
		)
        values
        (
			p_name,
      p_accession,
      p_fasta
		);
	END IF;
END$$

DELIMITER ;

# --------------------------------------------------------------------
# PROCEDURE TO DELETE AN ORGANISM FROM THE DATABASE WHOSE NAME IS THE
# GIVEN NAME
# --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `delete_organism_by_name`;
DELIMITER $$
USE `mitochondrial_genomics`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_organism_by_name`(
  IN p_name VARCHAR(45)
)
BEGIN
  IF (SELECT exists (SELECT 1 from organisms WHERE name = p_name) ) THEN
    
    DELETE FROM organisms WHERE name = p_name;
  
  ELSE
    
    SELECT 'Organism with given name does not exist';

  END IF;
END$$

DELIMITER ;

# --------------------------------------------------------------------
# PROCEDURE TO CHANGE THE SEQUENCE OF AN ORGANISM OF GIVEN NAME TO THE
# GIVEN SEQUENCE
# --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_sequence`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_sequence`(
  IN p_name VARCHAR(45),
    IN p_new_sequence VARCHAR(45)
)
BEGIN
  IF (SELECT EXISTS (SELECT 1 FROM organisms WHERE name = p_name) ) THEN
    
    UPDATE organisms SET mito_fasta_sequence = p_new_sequence WHERE name = p_name;
    
    ELSE
    
    SELECT 'No organism in database that has the given name.';
  END IF;
END$$

DELIMITER ;

# --------------------------------------------------------------------
# PROCEDURE TO RETRIEVE ALL ORGANISMS IN THE DB
# --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_sequence`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `retrieve_all_organisms`()
BEGIN
  
  SELECT * FROM organisms;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;












