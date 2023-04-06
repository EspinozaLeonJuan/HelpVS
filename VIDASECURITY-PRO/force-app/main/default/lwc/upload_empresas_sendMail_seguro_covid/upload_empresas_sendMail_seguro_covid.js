import { LightningElement, track, api } from 'lwc';

import uploadFile from '@salesforce/apex/CLS_LWC_Gestion_Seguro_Covid.uploadFileRutEmpresas';
import sendEmail from '@salesforce/apex/CLS_LWC_Gestion_Seguro_Covid.sendEmail';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'RUT Empresa', fieldName: 'RutEmpresa' , type: 'text' },
    { label: 'Existe Empresa', fieldName: 'ExisteEmpresa' , type: 'boolean' },
    { label: 'Nombre Empresa', fieldName: 'NombreEmpresa' , type: 'text' },
    // { label: 'Envio Correo Permitdo', fieldName: 'EnvioPermitido' , type: 'boolean' },
    // { label: 'Notificacion enviada', fieldName: 'NotificacionSeguroCovid' , type: 'boolean' },
    // { label: 'Fecha de envio', fieldName: 'CreatedDate', type: 'date',sortable: "true",
    // typeAttributes: {
    // day: 'numeric',
    // month: 'numeric',
    // year: 'numeric',
    // hour: '2-digit',
    // minute: '2-digit',
    // second: '2-digit',
    // hour24: true
    // }},

 ];

export default class Upload_empresas_sendMail_seguro_covid extends LightningElement {


    @api recordid;
    @track columns = columns;
    @track context;
    @track fileName = '';
    @track UploadFile = 'Upload CSV File';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    @track selectedRecords;
    @track filesUploaded = [];
    @track file;
    @track fileContents;
    @track fileReader;
    @track content;
    MAX_FILE_SIZE = 1500000;
    @track MAX_RESULT = 50;
    @track uploadCompleted = false;

    handleFilesChange(event) {

        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
        }
    }

    handleUpload() {
         if(this.filesUploaded.length > 0) {
             this.uploadHelper();
         }
         else {
            this.fileName = 'Por favor seleccione un archivo CSV para cargar!!';
         }
    }

    handleSendEmail() {
        console.log('handleSendEmail');
        this.showLoadingSpinner = true;
        this.sendToEmail();
    }

    handleRestart()
    {
        this.uploadCompleted = false;
        this.filename = '';
        this.page = 1;
        this.totalRecountCount = 0;
        this.totalPage = 0;
        this.totalRegistros_Query = 0;
        this.data = [];
        this.filesUploaded = '';
    }

    uploadHelper() {

        this.file = this.filesUploaded[0];
        if (this.file.size > this.MAX_FILE_SIZE) {

            window.console.log('File Size is to long');
            return ;

        }

        this.showLoadingSpinner = true;
        this.fileReader= new FileReader();
        this.fileReader.onloadend = (() => {
        this.fileContents = this.fileReader.result;
        this.uploadToFile();
        });

        this.fileReader.readAsText(this.file);
    }

    @track page = 1;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 20;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track data = [];
    @track totalRegistros_Query = 0;

   previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
   }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    displayRecordPerPage(page){
         this.startingRecord = ((page -1) * this.pageSize) ;
         this.endingRecord = (this.pageSize * page);
         this.endingRecord = (this.endingRecord > this.totalRecountCount)
                             ? this.totalRecountCount : this.endingRecord;
         this.data = this.context.slice(this.startingRecord, this.endingRecord);
         this.startingRecord = this.startingRecord + 1;
     }


    uploadToFile() {

         uploadFile({ jsonData: JSON.stringify(this.fileContents)})
             .then(result => {
                 window.console.log('result ====> ');
                 window.console.log(result);
                 this.context = result;

                 if (this.MAX_RESULT  >=  this.context.length)
                 {
                    this.totalRecountCount = this.context.length;
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

                    this.data = this.context.slice(0, this.pageSize);

                    this.totalRegistros_Query = this.context.length;

                    this.fileName = '';//this.fileName + ' - Uploaded Successfully';
                    this.isTrue = false;
                    this.showLoadingSpinner = false;
                    this.uploadCompleted = true;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Carga Exitosa!!',
                            message: this.file.name + ' - Ha sido Exitosamente cargado!!!',
                            variant: 'success',
                        }),
                    );
                 }
                 else{
                    this.fileName = this.fileName + ' - Uploaded Error';
                    this.isTrue = false;
                    this.showLoadingSpinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Carga con Problemas!!',
                            message: 'Solo pueden ser cargados '+ this.MAX_RESULT + ' registros a la vez.',
                            variant: 'error',
                        }),
                    );
                 }
             })
             .catch(error => {
                 window.console.log(error);
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Error while uploading File',
                         message: error.message,
                         variant: 'error',
                     }),

                 );
                this.isTrue = false;
                this.showLoadingSpinner = false;

             });
    }


    sendToEmail() {

        sendEmail({ jsonData: JSON.stringify(this.fileContents)})
            .then(result => {
                 window.console.log('result ====> ');
                 window.console.log(result);
                this.isTrue = false;
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Envío Correo Masivo',
                    message: 'Se han enviado '+result+' correos electrónicos para las cuentas cargadas!!!',
                        variant: 'success',
                    }),
                );
                this.uploadCompleted = false;
                this.filename = '';
                this.page = 1;
                this.totalRecountCount = 0;
                this.totalPage = 0;
                this.totalRegistros_Query = 0;
                this.data = [];
                this.filesUploaded = '';
            })

        }

}