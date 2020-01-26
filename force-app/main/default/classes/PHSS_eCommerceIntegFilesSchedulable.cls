public class PHSS_eCommerceIntegFilesSchedulable implements Schedulable {
   public void execute(SchedulableContext SC) {
      PHSS_eCommerceIntegrationFilesBatch bp = new PHSS_eCommerceIntegrationFilesBatch(false, 'CLIPS');
      Database.executeBatch(bp, 500);
   }
}