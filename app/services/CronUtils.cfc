component {
  public CronUtils function init() {
    variables.document = createObject('java', 'com.cronutils.descriptor.CronDescriptor');
    variables.utility = application.utility;
    return this;
  }
}
