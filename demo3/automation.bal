import ballerina/io;
import ballerina/log;
import ballerina/sql;
import ballerina/time;

public function main() returns error? {
    do {
        log:printInfo("Starting the ETL flow...");
        UnitInfo[] unitInfo = check io:fileReadCsv("/Users/chathura/work/temp/tt2/test1/files/ORGHIER_initial.csv");
        foreach UnitInfo uinfo in unitInfo {
            log:printInfo(uinfo.toJsonString(), 'unitDescription = uinfo.UNIT_DESCRIPTION_LONG, 'unitCode = uinfo.UNIT_CODE);
            Party party = mapParty(uinfo);
            log:printInfo(party.toJsonString());
            sql:ExecutionResult sqlExecutionresult = check uoeDB->execute(`INSERT INTO PARTY (
PARTY_ID, COMMENTS, INSERTDATETIME, PARTY_TYPE_ID,
ACTIVE_IND, FROM_DATE, SOURCE
) VALUES (
${party.PARTY_ID}, ${party.COMMENTS}, ${party.INSERTDATETIME}, ${party.PARTY_TYPE_ID},
${party.ACTIVE_IND}, ${party.FROM_DATE}, ${party.SOURCE}
)`);

            time:Civil? fromDate = convertToCivil(uinfo.ACTIVE_FROM_DATE);
            PartyIdentity partyIdentity = mapPartyIdentity(uinfo);
            PartyIdentity|sql:Error pid = uoeDB->queryRow(`SELECT * FROM PARTY_IDENTITY WHERE PARTY_ID = ${party.PARTY_ID} ACTIVE_IND = 'Y'`);
            if (pid is PartyIdentity) {
                if isSamePartyIdentities(pid, partyIdentity) {
                    partyIdentity.FROM_DATE = convertToCivil(uinfo.LAST_UPDATED);  
                    _ = check uoeDB->execute(`
                        UPDATE PARTY_IDENTITY 
                        SET ACTIVE_IND = 'N', 
                        WHERE PARTY_ID = ${partyIdentity.PARTY_ID} AND ACTIVE_IND = 'Y';
                    `);   
                }
            }
            _ = check uoeDB->execute(`
                    INSERT INTO PARTY_IDENTITY (PARTY_ID, PARTY_IDENTITY_TYPE, IDENTITY, INSERTDATETIME, ACTIVE_IND, FROM_DATE, DESCRIPTION, SOURCE) 
                    VALUES (${partyIdentity.PARTY_ID}, ${partyIdentity.PARTY_IDENTITY_TYPE}, ${partyIdentity.IDENTITY}, 
                            ${partyIdentity.INSERTDATETIME}, ${partyIdentity.ACTIVE_IND}, ${partyIdentity.FROM_DATE}, 
                            ${partyIdentity.DESCRIPTION}, ${partyIdentity.SOURCE});
                `);

            PartyRole partyRole = mapPartyRole(uinfo);
            _ = check uoeDB->execute(`
                    INSERT INTO PARTY_ROLE (PARTY_ID, ROLETYPE_ID, INSERTDATETIME, ACTIVE_IND, FROM_DATE, PARTY_ROLE_ID, SOURCE, PARTY_ROLE_LINK_ID) 
                    VALUES (${partyRole.PARTY_ID}, ${partyRole.ROLETYPE_ID}, ${partyRole.INSERTDATETIME}, ${partyRole.ACTIVE_IND}, ${partyRole.FROM_DATE}, 
                            ${partyRole.PARTY_ROLE_ID}, ${partyRole.SOURCE}, ${partyRole.PARTY_ROLE_LINK_ID});
                `); 

            PartyRelationship partyRelationship = mapPartyRelationship(uinfo);
            _ = check uoeDB->execute(`
                INSERT INTO PARTY_RELATIONSHIP (PARTY_ID_FROM, PARTY_ID_TO, REL_FROM_DATE, PARTY_ROLE_FROM, 
                                                PARTY_ROLE_TO, PARTYRELTYPE_ID, INSERTDATETIME, ACTIVE_IND, 
                                                REL_TO_DATE, SOURCE, PARTY_RELATIONSHIP_ID) 
                VALUES (${partyRelationship.PARTY_ID_FROM}, ${partyRelationship.PARTY_ID_TO}, ${partyRelationship.REL_FROM_DATE}, ${partyRelationship.PARTY_ROLE_FROM}, 
                        ${partyRelationship.PARTY_ROLE_TO}, ${partyRelationship.PARTYRELTYPE_ID}, ${partyRelationship.INSERTDATETIME}, ${partyRelationship.ACTIVE_IND}, 
                        ${partyRelationship.REL_TO_DATE}, ${partyRelationship.SOURCE}, ${partyRelationship.PARTY_RELATIONSHIP_ID});
            `);

            // loop is broken after inserting the first record for testing purposes
            break;
        }
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
