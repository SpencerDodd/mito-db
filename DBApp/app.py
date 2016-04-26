from flask import Flask, render_template, request, json
from flask.ext.mysql import MySQL
from werkzeug import generate_password_hash, check_password_hash
import os

app = Flask(__name__)
mysql = MySQL()

# MySQL configs
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'mitochondrial_genomics'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


# RENDER TEMPLATES
@app.route("/")
def main():
	return render_template('index.html')

@app.route("/showAddNewOrganism")
def showAddNewOrganism():
	return render_template('add_new_organism.html')

@app.route("/showDeleteOrganism")
def showDeleteOrganism():
	return render_template('delete_organism.html')

@app.route("/showUpdateSequence")
def showUpdateSequence():
	return render_template('update_sequence.html')

@app.route("/showViewOrganisms")
def showViewOrganisms():
	organisms_in_db = retrieve_all_organisms()
	print organisms_in_db
	return render_template('view_organisms.html', organisms=organisms_in_db)

# Methods for showing feedback from entries TODO
def showSuccessfulAction():
	print "SUCCESS"
	return render_template('successful_action.html')

# creates a file with a given fasta sequence and returns the file_path of the
# resulting file, to be stored in the database
def file_from_seq(organism_name, sequence):

	file_path_name = "seqs/{1}.txt".format(os.getcwd(), organism_name)
	full_path = "{0}/{1}"

	print file_path_name

	with open(file_path_name, 'wb+') as f:

		f.write(sequence)

	f.close()
	return file_path_name


# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------
# MEAT METHODS FOR INTERACTING WITH DB
# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------
@app.route("/addNewOrganism", methods=['POST', 'GET'])
def addNewOrganism():
	try:
		_organism_name = request.form['organismName']
		_accession_number = request.form['accessionNumber']
		_fasta_sequence = request.form['fastaSequence']

		# store seq on disk and return file_path
		_seq_path = file_from_seq(_organism_name, _fasta_sequence)

		# validate received values
		if _organism_name and _accession_number and _fasta_sequence:

			# call MySQL
			conn = mysql.connect()
			cursor = conn.cursor()
			cursor.callproc('add_organism',(_organism_name, _accession_number, _seq_path))
			data = cursor.fetchall()

			if len(data) is 0:
				conn.commit()
				showSuccessfulAction() # TODO
				return json.dumps({'message':'Organism {0} successfully added !'.format(_organism_name)})
				
			else:
				return json.dumps({'error':str(data[0])})
		else:
			return json.dumps({'html':'<span>Enter the required fields</span>'})

	except Exception as e:
		return json.dumps({'error':str(e)})
	finally:
		cursor.close()
		conn.close()

@app.route("/deleteOrganism", methods=['POST', 'GET'])
def deleteOrganism():
	try:
		_organism_name = request.form['organismName']

		# validate received values
		if _organism_name:

			# call MySQL
			conn = mysql.connect()
			cursor = conn.cursor()
			cursor.callproc('delete_organism_by_name',(_organism_name,))
			data = cursor.fetchall()

			if len(data) is 0:
				conn.commit()
				showSuccessfulAction() # TODO
				return json.dumps({'message':'Organism {0} successfully deleted !'.format(_organism_name)})
				
			else:
				return json.dumps({'error':str(data[0])})
		else:
			return json.dumps({'html':'<span>Enter the required fields</span>'})

	except Exception as e:
		return json.dumps({'error':str(e)})
	finally:
		cursor.close()
		conn.close()

@app.route("/updateSequence", methods=['POST', 'GET'])
def updateSequence():
	try:
		_organism_name = request.form['organismName']
		_new_sequence = request.form['fastaSequence']

		_seq_path = file_from_seq(_organism_name, _new_sequence)

		# validate received values
		if _organism_name:

			# call MySQL
			conn = mysql.connect()
			cursor = conn.cursor()
			cursor.callproc('update_sequence',(_organism_name, _seq_path))
			data = cursor.fetchall()

			if len(data) is 0:
				conn.commit()
				showSuccessfulAction() # TODO
				return json.dumps({'message':'Sequence for organism {0} successfully updated !'.format(_organism_name)})
				
			else:
				return json.dumps({'error':str(data[0])})
		else:
			return json.dumps({'html':'<span>Enter the required fields</span>'})

	except Exception as e:
		return json.dumps({'error':str(e)})
	finally:
		cursor.close()
		conn.close()

@app.route("/retrieveAllOrganisms")
def retrieve_all_organisms():

	try:

		conn = mysql.connect()
		cursor = conn.cursor()
		cursor.callproc('retrieve_all_organisms')
		data = cursor.fetchall()

		if len(data) is 0:
			return json.dumps({'message':'Database contains no organisms'})
		else:

			return data

	except Exception as e:
		return json.dumps({'error':str(e)})
	finally:
		cursor.close()
		conn.close()


if __name__ == "__main__":
	app.run(port=5000)











