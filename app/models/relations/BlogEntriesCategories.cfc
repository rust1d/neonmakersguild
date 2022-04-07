component extends=BaseRelation accessors=true {
  public void function replace(required string bcaids) {
    var sproc = new StoredProc(procedure: 'blogentriescategories_replace', datasource: application.dsn);
    sproc.addParam(cfsqltype: 'integer', value: parent.primary_key());
    sproc.addParam(cfsqltype: 'varchar', value: bcaids.listRemoveDuplicates());
    sproc.execute();
    reset(); // CLEARS RELATION DATA WHICH IS INVALID NOW; WILL RELOAD ON NEXT REQUEST
  }
}
