import ballerina/time;

// Record type for ORG_HIERARCHY_SCD table
public type OrgHierarchyScd record {|
    string? ORG_UNIT_SK;
    string? ORG_UNIT_ID;
    string? HIERARCHY_TYPE;
    string? LEVEL1_ID;
    string? LEVEL1_CODE;
    string? LEVEL1;
    string? LEVEL2_ID;
    string? LEVEL2_CODE;
    string? LEVEL2;
    string? LEVEL3_ID;
    string? LEVEL3_CODE;
    string? LEVEL3;
    string? LEVEL4_ID;
    string? LEVEL4_CODE;
    string? LEVEL4;
    string? LEVEL5_ID;
    string? LEVEL5_CODE;
    string? LEVEL5;
    string? LEVEL6_ID;
    string? LEVEL6_CODE;
    string? LEVEL6;
    time:Civil? ROW_START_DATE;
    time:Civil? ROW_END_DATE;
    string? ROW_ACTIVE_IND;
|};

// Record type for PARTY table
public type Party record {|
    string? PARTY_ID;
    string? COMMENTS;
    time:Civil? INSERTDATETIME;
    string? PARTY_TYPE_ID;
    string? ACTIVE_IND;
    time:Civil? FROM_DATE;
    string? SOURCE;
|};

// Record type for PARTY_ROLE table
public type PartyRole record {|
    string? PARTY_ID;
    string? ROLETYPE_ID;
    time:Civil? INSERTDATETIME;
    string? ACTIVE_IND;
    time:Civil? FROM_DATE;
    string? PARTY_ROLE_ID;
    string? SOURCE;
    string? PARTY_ROLE_LINK_ID;
|};

// Record type for PARTY_IDENTITY table
public type PartyIdentity record {|
    string? PARTY_ID;
    string? PARTY_IDENTITY_TYPE;
    string? IDENTITY;
    time:Civil? INSERTDATETIME;
    string? ACTIVE_IND;
    time:Civil? FROM_DATE;
    string? DESCRIPTION;
    string? SOURCE;
|};

// Record type for PARTY_RELATIONSHIP table
public type PartyRelationship record {|
    string? PARTY_ID_FROM;
    string? PARTY_ID_TO;
    time:Civil? REL_FROM_DATE;
    string? PARTY_ROLE_FROM;
    string? PARTY_ROLE_TO;
    string? PARTYRELTYPE_ID;
    time:Civil? INSERTDATETIME;
    string? ACTIVE_IND;
    time:Civil? REL_TO_DATE;
    string? SOURCE;
    string? PARTY_RELATIONSHIP_ID;
|};

// Record type for Unit information
public type UnitInfo record {|
    string? UNIT_CODE;
    string? UNIT_DESCRIPTION_LONG;
    string? UNIT_DESCRIPTION_SHORT;
    string? UNIT_LEVEL;
    string? UNIT_PARENT;
    string? UNIT_ADDRESS_LINE_1;
    string? UNIT_ADDRESS_LINE_2;
    string? UNIT_ADDRESS_LINE_3;
    string? UNIT_POSTCODE;
    string? ACTIVE_FROM_DATE;
    string? INACTIVE_FROM_DATE;
    string? LAST_UPDATED;
    string? LOAD_DATE;
|};