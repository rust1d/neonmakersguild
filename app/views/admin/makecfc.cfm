<cfscript>
  numeric function lines(string data) {
    return data.listLen(chr(13), true);
  }

  if (!application.isDevelopment) abort;

  // variables.CR = chr(13) & chr(10);
  sMaker = new app.services.makecfc.ModelMaker();
  schemas = sMaker.get_schemas();
  param form.schema = schemas.last().schema_name;
  tables = sMaker.get_tables(form.schema);
  param form.table = tables.first().table_name;
  param form.writeit = ifin(form.keyExists('btnWrite'), 1, 0);
  param form.writeto = sMaker.db_path(form.schema);

  try {
    sTable = sMaker.get_table(form.schema, form.table, form.writeto);
    output = {
      model: sTable.model(form.schema, form.table),
      search: sTable.sproc_search(),
      insert: sTable.sproc_insert(),
      update: sTable.sproc_update(),
      delete: sTable.sproc_delete(),
      get_by_ids: sTable.sproc_get_by_ids()
    }
  } catch (any err) {
    flash.cferror(err);
    output = { model: '' };
  }
</cfscript>

<cfoutput>
  #router.include('shared/flash')#

  <form method='post'>
    <div class='row g-3 mb-5'>
      <div class='col-6 col-xxl-4'>
        <div class='input-group'>
          <label class='input-group-text' for='schema'>Schema</label>
          <select class='form-select' name='schema' onchange='postButton(this)'>
            <cfloop array='#schemas#' item='schema'>
              <option value='#schema.schema_name#' #ifin(schema.schema_name EQ form.schema)#>#schema.schema_name#</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class='col-6 col-xxl-4'>
        <div class='input-group'>
          <label class='input-group-text' for='table'>Table</label>
          <select class='form-select' name='table' onchange='this.form.submit()'>
            <cfloop array='#tables#' item='table'>
              <option value='#table.table_name#' #ifin(table.table_name EQ form.table)#>#table.table_name#</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class='col-12 col-xxl-8'>
        <div class='input-group'>
          <label class='input-group-text' for='writeto'>Output Folder</label>
          <input type='text' class='form-control' name='writeto' size='50' value='#form.writeto#' />
          <button type='submit' name='btnWrite' class='btn bg-success-subtle'>Write Sprocs!</button>
        </div>
      </div>
    </div>
  </form>

  <cfif output.model.len()>
    <div class='row'>
      <div class='col-8'>
        <div class='row'>
          <div class='col-12'>
            <h3>#form.table# Model</h3>
            <textarea class='form-control font-monospace' rows='#lines(output.model)+1#' data-clipboard>#output.model#</textarea><br>
          </div>
          <div class='col-12'>
            <div class='accordion' id='sprocs'>
              <cfloop list='search,insert,update,delete,get_by_ids' item='sproc'>
                <div class='accordion-item'>
                  <h2 class='accordion-header'>
                    <button class='accordion-button' type='button' data-bs-toggle='collapse' data-bs-target='##sproc_#sproc#' aria-expanded='true' aria-controls='collapseOne'>
                      #form.table#_#sproc#.sql
                    </button>
                  </h2>
                  <div id='sproc_#sproc#' class='accordion-collapse collapse show' data-bs-parent='##sprocs'>
                    <div class='accordion-body'>
                      <textarea class='form-control font-monospace text-small' rows='#lines(output[sproc])#' data-clipboard>#output[sproc]#</textarea><br>
                    </div>
                  </div>
                </div>
              </cfloop>
            </div>
          </div>
        </div>
      </div>
      <div class='col-4'>
        <h3>#form.table# Builder</h3>
        <table class='table table-sm text-small table-hover'>
          <thead>
            <tr class='table-light'>
              <th>Field</th>
              <th>Key</th>
              <th>Timestamp</th>
              <th>Search</th>
            </tr>
          </thead>
          <tbody>
            <cfloop array='#sTable.data().columns#' item='col'>
              <tr>
                <td>#col.name#</td>
                <td>#col.COLUMN_KEY#</td>
                <td>
                  #col.stamp#
                </td>
                <td>
                  <input type='checkbox' #ifin(col.search,'checked')# />
                </td>
              </tr>
            </cfloop>
          </tbody>
        </table>
      </div>
    </div>
  </cfif>
</cfoutput>
