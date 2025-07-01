component extends=BaseRelation accessors=true {
  public void function replace(required string ids) {
    var sproc = new StoredProc(procedure: 'BlogEntryCategories_replace', datasource: application.dsn);
    sproc.addParam(cfsqltype: 'integer', value: parent.primary_key());
    sproc.addParam(cfsqltype: 'varchar', value: ids.listRemoveDuplicates());
    sproc.execute();
    reset(); // CLEARS RELATION DATA WHICH IS INVALID NOW; WILL RELOAD ON NEXT REQUEST
  }
}
