trigger TRG_ActualizaDatosContacto on Contratante__c (before update, after update) {
	
    if(Trigger.isAfter){ // DESPUES...
    
        Contratante__c c = Trigger.new[0];
        
        
        String Region, Ciudad, Comuna;
        /*
        Region = [select Name from Region__c where id =: c.CONTRA_Region__c].Name;
        Ciudad = [select Name from Ciudad__c where id =: c.CONTRA_Ciudad__c].Name;
        Comuna = [select Name from Comuna__c where id =: c.CONTRA_Comuna__c].Name;
        */

        system.debug('@@@@ ID CONTRATANTE => ' + c.CONTRA_ID_Contratante_Propuesta__c);
        
        List<Persona__c> LPER = new List<Persona__c>();
        LPER = [SELECT Id, Name, PERSO_Rut__c, PERSO_Dv__c, PERSO_Apellido_Paterno__c, PERSO_Apellido_Materno__c, 
                PERSO_Mail__c, PERSO_Telefono_Fijo__c, PERSO_Telefono_Movil__c, PERSO_Direccion__c, 
                PERSO_Codigo_Comuna__c, PERSO_Codigo_Ciudad__c, PERSO_Codigo_Region__c, PERSO_Fecha_de_Nacimiento__c, 
                PERSO_ID_Persona_Propuesta__c 
                FROM Persona__c 
                WHERE PERSO_ID_Persona_Propuesta__c =: c.CONTRA_ID_Contratante_Propuesta__c];
        if(LPER.size() > 0){
            for(Persona__c p : LPER){
                p.PERSO_Telefono_Fijo__c = c.CONTRA_Telefono_1__c;
                p.PERSO_Telefono_Movil__c = c.CONTRA_Telefono_2__c;
                p.PERSO_Mail__c = c.CONTRA_Email_1__c;
                p.PERSO_Direccion__c = c.CONTRA_Direccion__c;
                p.PERSO_Codigo_Region__c = c.CONTRA_Codigo_Region__c;
                p.PERSO_Codigo_Ciudad__c = c.CONTRA_Codigo_Ciudad__c;
                p.PERSO_Codigo_Comuna__c = c.CONTRA_Codigo_Comuna__c;
            }
            update LPER;
        }
        
        List<Asegurado__c> LASE = new List<Asegurado__c>();
        LASE = [SELECT Id, Name, ASEG_Tipo_de_Folio__c, ASEG_Propuesta__c, ASEG_Regi_n__c, ASEG_Codigo_Relacion__c, 
                ASEG_Persona__c, ASEG_ID_Asegurado_Propuesta__c, ASEG_Relacion__c, ASEG_Dv__c, ASEG_Telefono_1__c, 
                ASEG_Telefono_2__c, ASEG_Email_1__c, ASEG_Email_2__c, ASEG_Fecha_de_Nacimiento__c, ASEG_Rut__c, 
                ASEG_Direccion__c, ASEG_Codigo_Region__c, ASEG_Codigo_Ciudad__c, ASEG_Codigo_Comuna__c, 
                ASEG_Apellido_Paterno__c, ASEG_Apellido_Materno__c, ASEG_Ciudad__c, ASEG_Comuna__c
                FROM Asegurado__c 
                WHERE ASEG_ID_Asegurado_Propuesta__c =: c.CONTRA_ID_Contratante_Propuesta__c];
        if(LASE.size() > 0){
            for(Asegurado__c a : LASE){
                a.ASEG_Telefono_1__c = c.CONTRA_Telefono_1__c;
                a.ASEG_Telefono_2__c = c.CONTRA_Telefono_2__c;
                a.ASEG_Email_1__c = c.CONTRA_Email_1__c;
                a.ASEG_Email_2__c = c.CONTRA_Email_2__c;
                a.ASEG_Direccion__c = c.CONTRA_Direccion__c;
                a.ASEG_Codigo_Region__c = c.CONTRA_Codigo_Region__c;
                a.ASEG_Codigo_Ciudad__c = c.CONTRA_Codigo_Ciudad__c;
                a.ASEG_Codigo_Comuna__c = c.CONTRA_Codigo_Comuna__c;
                a.ASEG_Regi_n__c = Region;
                a.ASEG_Ciudad__c = Ciudad;
                a.ASEG_Comuna__c = Comuna;
            }
            update LASE;
        }   
        
        List<Beneficiario2__c> LBEN = new List<Beneficiario2__c>();
        LBEN = [SELECT Id, Name, BEN_Apellido_Paterno__c, BEN_Propuesta__c, BEN_Tipo_de_Folio__c, BEN_Codigo_Relacion__c, 
                BEN_Participacion__c, BEN_Persona__c, BEN_ID_Beneficiario_Propuesta__c, BEN_Fecha_de_Nacimiento__c, 
                BEN_Relacion__c, BEN_Dv__c, BEN_Rut__c, BEN_Apellido_Materno__c, BEN_C_digo_Comuna__c, BEN_Comuna__c, 
                BEN_C_digo_Ciudad__c, BEN_Ciudad__c, BEN_C_digo_Regi_n__c, BEN_Regi_n__c, BEN_Direcci_n__c, 
                BEN_Tel_fono_1__c, BEN_Tel_fono_2__c, BEN_Email_1__c, BEN_Email_2__c 
                FROM Beneficiario2__c
                WHERE BEN_ID_Beneficiario_Propuesta__c =: c.CONTRA_ID_Contratante_Propuesta__c];
        if(LBEN.size() > 0){
            for(Beneficiario2__c b : LBEN){
                b.BEN_Tel_fono_1__c = c.CONTRA_Telefono_1__c;
                b.BEN_Tel_fono_2__c = c.CONTRA_Telefono_2__c;
                b.BEN_Email_1__c = c.CONTRA_Email_1__c;
                b.BEN_Email_2__c = c.CONTRA_Email_2__c;
                b.BEN_Direcci_n__c = c.CONTRA_Direccion__c;
                b.BEN_C_digo_Regi_n__c = c.CONTRA_Codigo_Region__c;
                b.BEN_C_digo_Ciudad__c = c.CONTRA_Codigo_Ciudad__c;
                b.BEN_C_digo_Comuna__c = c.CONTRA_Codigo_Comuna__c;
                b.BEN_Regi_n__c = Region;
                b.BEN_Ciudad__c = Ciudad;
                b.BEN_Comuna__c = Comuna;
            }
            update LBEN;
        } 
    }else{
       
        /*
        Contratante__c c = Trigger.new[0];
        
        String Region, Ciudad, Comuna;
        Region = [select REGI_C_digo__c from Region__c where id =: c.CONTRA_Region__c].REGI_C_digo__c;
        Ciudad = [select CIUD_C_digo__c from Ciudad__c where id =: c.CONTRA_Ciudad__c].CIUD_C_digo__c;
        Comuna = [select COMU_Codigo_Comuna__c from Comuna__c where id =: c.CONTRA_Comuna__c].COMU_Codigo_Comuna__c; 
        c.CONTRA_Codigo_Region__c = Region;
        c.CONTRA_Codigo_Ciudad__c = Ciudad;
        c.CONTRA_Codigo_Comuna__c = Comuna;
        */
    }
    
}