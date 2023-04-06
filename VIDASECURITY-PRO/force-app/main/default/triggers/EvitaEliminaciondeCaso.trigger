trigger EvitaEliminaciondeCaso on Case (before delete) {
ID profileId = UserInfo.getProfileId();
    String ProfileName = [select Id, Name from profile where Id=:ProfileId].Name;
    
    for (case cs : trigger.old)
    {
        if (profileName == 'Ejecutivo Calidad LGN' && cs.RecordTypeId !='012i0000000xqP8AAI')
          
        {
            cs.addError('No se permite la eliminación del registro');
        }
    }
}