import ballerina/crypto;
import ballerina/time;
import ballerina/sql;

function convertPartyId(string? partyId) returns string {
    if partyId is () {
        return "";
    }
    return crypto:hashSha256(partyId.toBytes()).toBase64() + "_" + partyId;
}

# Converts a date string in format "DD-MMM-YYYY HH.mm" to time:Civil
#
# + dateString - Date string in format "DD-MMM-YYYY HH.mm"
# + return - time:Civil value if conversion is successful, error if the date string is invalid
function convertToCivil(string? dateString) returns time:Civil? {
    if dateString is () {
        return ();
    }
    // Map of month abbreviations to numbers
    map<string> monthMap = {
        "JAN": "01",
        "FEB": "02",
        "MAR": "03",
        "APR": "04",
        "MAY": "05",
        "JUN": "06",
        "JUL": "07",
        "AUG": "08",
        "SEP": "09",
        "OCT": "10",
        "NOV": "11",
        "DEC": "12"
    };

    // Split date and time parts
    string[] parts = re `\s+`.split(dateString);
    if parts.length() != 2 {
        return ();
    }

    // Split date components
    string[] dateParts = re `-`.split(parts[0]);
    if dateParts.length() != 3 {
        return ();
    }

    string day = dateParts[0];
    string monthAbbr = dateParts[1];
    string year = dateParts[2];

    // Get month number
    string? month = monthMap[monthAbbr];
    if month is () {
        return ();
    }

    // Convert time format from HH.mm to HH:mm
    string[] timeParts = re `\.`.split(parts[1]);
    if timeParts.length() != 2 {
        return ();
    }
    string timeStr = string `${timeParts[0]}:${timeParts[1]}`;

    // Construct RFC 3339 format
    string rfc3339Str = string `${year}-${month}-${day}T${timeStr}:00Z`;

    time:Civil|error date = time:civilFromString(rfc3339Str);
    if date is error {
        return ();
    }
    date.utcOffset = ();
    return date;
}

function isSamePartyIdentities(PartyIdentity pid1, PartyIdentity pid2) returns boolean {
    if pid1.PARTY_ID == pid2.PARTY_ID && pid1.DESCRIPTION == pid2.DESCRIPTION {
        return true;
    }
    return false;
}

function constructPartyRoleId(string? level) returns string {
    if level is () {
        return "";
    }
    return "UOE_LEVEL" + level;
}

function constructLevel(string? level) returns string {
    if level is () {
        return "";
    }
    return "UOE_LEVEL" + level;
}

function getPartyRole(string? partyId) returns string {
    if partyId is () {
        return "";
    }
    string|sql:Error result = uoeDB->queryRow(`SELECT PARTY_ROLE_ID FROM PARTY_ROLE WHERE PARTY_ID = ${partyId} AND ACTIVE_IND = 'Y'`);
    if result is string {
        return result;
    }
    return "";
}
