function mapParty(UnitInfo unitInfo) returns Party => {
    FROM_DATE: convertToCivil(unitInfo.ACTIVE_FROM_DATE),
    PARTY_TYPE_ID: <string>"UOE_PARTY_TYPE",
    INSERTDATETIME: convertToCivil(unitInfo.LOAD_DATE),
    ACTIVE_IND: <string>"Y",
    SOURCE: <string>"ORG_HIERARCH",

    PARTY_ID: convertPartyId(unitInfo.UNIT_CODE),
    COMMENTS: <()>()
};

function mapPartyIdentity(UnitInfo uinfo) returns PartyIdentity => {
    PARTY_ID: convertPartyId(uinfo.UNIT_CODE),
    PARTY_IDENTITY_TYPE: "UOE_ORG_UNIT",
    IDENTITY: uinfo.UNIT_CODE,
    INSERTDATETIME: convertToCivil(uinfo.LOAD_DATE),
    ACTIVE_IND: "Y",
    FROM_DATE: convertToCivil(uinfo.ACTIVE_FROM_DATE),
    DESCRIPTION: uinfo.UNIT_DESCRIPTION_LONG,
    SOURCE: "ORG_HIERARCY"
};

function mapPartyRole(UnitInfo uinfo) returns PartyRole => {
    PARTY_ID: convertPartyId(uinfo.UNIT_CODE),
    ROLETYPE_ID: "UOE_HIERARCHY_LEVEL",
    INSERTDATETIME: convertToCivil(uinfo.LOAD_DATE),
    ACTIVE_IND: "Y",
    FROM_DATE: convertToCivil(uinfo.ACTIVE_FROM_DATE),
    PARTY_ROLE_ID:  constructLevel(uinfo.UNIT_LEVEL),
    SOURCE: "ORG_HIERARCY",
    PARTY_ROLE_LINK_ID: ""
};

function mapPartyRelationship(UnitInfo uinfo) returns PartyRelationship => {
    PARTY_ID_FROM: convertPartyId(uinfo.UNIT_CODE),
    PARTY_ID_TO: convertPartyId(uinfo.UNIT_PARENT),
    REL_FROM_DATE: convertToCivil(uinfo.ACTIVE_FROM_DATE),
    PARTY_ROLE_FROM: constructLevel(uinfo.UNIT_LEVEL),
    PARTY_ROLE_TO: getPartyRole(uinfo.UNIT_PARENT),
    PARTYRELTYPE_ID: "UOE_ORG_HIERARCHY_ROLLUP",
    INSERTDATETIME: convertToCivil(uinfo.LOAD_DATE),
    ACTIVE_IND: "Y",
    REL_TO_DATE: (),
    SOURCE: "ORG_HIERARCY",
    PARTY_RELATIONSHIP_ID: convertPartyId(uinfo.UNIT_CODE) + "_" + convertPartyId(uinfo.UNIT_PARENT)
};