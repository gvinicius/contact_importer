import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import MaterialTable from 'material-table';

import TablePagination from '@material-ui/core/TablePagination';
import Input from '@material-ui/core/Input';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Snackbar from '@material-ui/core/Snackbar';
import Alert from '@material-ui/lab/Alert';

const Landing = () => {
  const [imports, setImport] = useState([]);
  const [contacts, setContacts] = useState([]);
  const [file, setFile] = useState();
  const [requestResult, setRequestResult] = useState();
  const url = 'api/v1/imports';
  const contactsUrl = 'api/v1/contacts';

  const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  function retrieveImport() {
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network error.");
      })
      .then((data) => {
        setImport(data);
      })
      .catch((err) => message.error("Error: " + err));
  }

  function retrieveContacts() {
    fetch(contactsUrl)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network error.");
      })
      .then((data) => {
        setContacts(data);
      })
      .catch((err) => message.error("Error: " + err));
  }

  useEffect(() => {
    retrieveImport();
    retrieveContacts();
  }, [file]);

  const handleSubmit = (file) => {
    if(file === undefined || file === '') {
      return null;
    }
    const data = new FormData()
    data.append('file', file)
    setFile();
    fetch(url, {
      method: 'POST',
      body: data
    }).then(response=>response.json())
      .then(data=>{ setRequestResult('ok'); })
    ;
  }

  const handleClose = () => {
    setRequestResult();
  };

  return (
    <div>
      <div>
        <AppBar position="static">
          <Toolbar variant="dense">
            <Typography variant="h6" color="inherit">
              Contact Importer
            </Typography>
          </Toolbar>
        </AppBar>
        <form id='uploadForm'
          handleSubmit={handleSubmit(file)}>
          <Input name="file" type="file" hidden onChange={(value) => { value.target && value.target.files && setFile(value.target.files[0]) }} />
      </form>
        <Snackbar open={requestResult !== undefined} autoHideDuration={6000} onClose={handleClose}>
          <Alert onClose={handleClose} severity='success' >
           File Uploaded
          </Alert>
        </Snackbar>
      </div>
      <div style={{ maxWidth: "100%" }}>
        <MaterialTable
          options={{
            pageSize: 5,
            selection: false,
            paginationType: "normal",
            pageSizeOptions: [5, 10, 20],
            sorting: false,
            search: false,
            emptyRowsWhenPaging: false,
            showFirstLastPageButtons: true,
            draggable: false,
            rowStyle: (data, index) => {
              if (index % 2) {
                return { backgroundColor: "#f1f1f1" };
              }
            },
          }}

          columns={[
            { title: "Id", field: "id" },
            { title: "Total", field: "total" },
            { title: "Status", field: "status" },
            { title: "Report", field: "report" },
          ]}
          data={imports}
          title="Imports"
          components={{
            Pagination: (props) => {
              return (
                <TablePagination
                  component="div"
                  backIconButtonProps={{ 'aria-label': '<' }}
                  nextIconButtonProps={{ 'aria-label': '>' }}
                  labelRowsPerPage='Per page: '
                  labelDisplayedRows={({ from, to, count }) => `${from}-${to} from ${count}`}
                  count={imports.length}
                  page={props.page}
                  rowsPerPage={props.rowsPerPage}
                  rowsPerPageOptions={props.rowsPerPageOptions}
                  onPageChange={props.onPageChange}
                  onChangePage={props.onPageChange}
                  onChangeRowsPerPage={props.onRowsPerPageChange}
                  onRowsPerPageChange={props.onRowsPerPageChange}

                />
              )
            }
          }}
        />
        <MaterialTable
          options={{
            pageSize: 5,
            selection: false,
            paginationType: "normal",
            pageSizeOptions: [5, 10, 20],
            sorting: false,
            search: false,
            emptyRowsWhenPaging: false,
            showFirstLastPageButtons: true,
            draggable: false,
            rowStyle: (data, index) => {
              if (index % 2) {
                return { backgroundColor: "#f1f1f1" };
              }
            },
          }}

          columns={[
            { title: "name", field: "name" },
            { title: "Date of Birth", field: "date_of_birth" },
            { title: "Phone", field: "phone" },
            { title: "Address", field: "address" },
            { title: "Credit Card", field: "card_ref" },
            { title: "Franchise", field: "franchise" },
            { title: "Email", field: "email" },

          ]}
          data={contacts}
          title="Contacts"
          components={{
            Pagination: (props) => {
              return (
                <TablePagination
                  component="div"
                  backIconButtonProps={{ 'aria-label': '<' }}
                  nextIconButtonProps={{ 'aria-label': '>' }}
                  labelRowsPerPage='Per page: '
                  labelDisplayedRows={({ from, to, count }) => `${from}-${to} from ${count}`}
                  count={imports.length}
                  page={props.page}
                  rowsPerPage={props.rowsPerPage}
                  rowsPerPageOptions={props.rowsPerPageOptions}
                  onPageChange={props.onPageChange}
                  onChangePage={props.onPageChange}
                  onChangeRowsPerPage={props.onRowsPerPageChange}
                  onRowsPerPageChange={props.onRowsPerPageChange}

                />
              )
            }
          }}
        />
      </div>
    </div>
  )}


Landing.propTypes = {
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Landing name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})
