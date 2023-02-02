<cfscript>
  if (form.keyExists('btnSubmit')) {
    mProfile.set(form);
    if (mProfile.safe_save()) flash.success('Your information was saved.');
  }
</cfscript>

<script src='/assets/js/image/select.js'></script>

<cfoutput>
  <form method='post'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>Membership T-Shirt</h5>
      <div class='card-body'>
        <p class='smaller'>
          All members get an official Neon Maker's Guild T-Shirt for signing up.
          We will be bulk ordering and shipping the shirts early this fall.
        </p>

        <div class='row'>
          <div class='col-12 col-lg-6 mb-3'>
            <p class='smaller'>Please provide a shipping address.</p>
            <div class='row'>
              <div class='col-12 mb-3'>
                <label class='form-label' for='up_address1'>Address 1</label>
                <input type='text' class='form-control' name='up_address1' id='up_address1' value='#encodeForHTML(mProfile.address1())#' maxlength='50' />
              </div>
              <div class='col-12 mb-3'>
                <label class='form-label' for='up_address2'>Address 2</label>
                <input type='text' class='form-control' name='up_address2' id='up_address2' value='#encodeForHTML(mProfile.address2())#' maxlength='25' />
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <div class='row'>
                  <div class='col-12 mb-3'>
                    <label class='form-label' for='up_city'>City</label>
                    <input type='text' class='form-control' name='up_city' id='up_city' value='#encodeForHTML(mProfile.city())#' maxlength='25' />
                  </div>
                  <div class='col-12 mb-3'>
                    <label class='form-label' for='up_region'>State/Region Code</label>
                    <input type='text' class='form-control' name='up_region' id='up_region' value='#encodeForHTML(mProfile.region())#' maxlength='25' />
                  </div>
                  <div class='col-12 mb-3'>
                    <label class='form-label' for='up_postal'>ZIP/Postal Code</label>
                    <input type='text' class='form-control' name='up_postal' id='up_postal' value='#mProfile.postal()#' maxlength='12' />
                  </div>
                  <div class='col-12 mb-3'>
                    <label class='form-label' for='up_country'>Country Code</label>
                    <input type='text' class='form-control' name='up_country' id='up_country' value='#mProfile.country()#' maxlength='2' />
                  </div>
                </div>
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <img src='assets/images/shirtsample.png' class='w-100' />
              </div>
            </div>
          </div>
          <div class='col-12 col-lg-6 mb-3'>
            <p class='smaller'>
              Please enter the size you would like below.
            </p>
            <label class='form-label' for='up_promo'>T-Shirt Size</label>
            <select name='up_promo' id='up_promo' class='form-control'>
              <option>Not Provided</option>
              <cfloop list='Small,Medium,Large,X-Large,2X-Large,3X-Large' item='size'>
                <option value='#size#' #ifin(size==mProfile.promo(), 'selected')#>#size#</option>
              </cfloop>
            </select>
            <div class='smaller mt-3'>
              <p>
                T-shirts are Gildan, unisex 100% ring-spun, pre-shrunk cotton. Use the following size chart:
              </p>
              <table class='table table-sm'>
                <tr><th>SIZE</th><th>INCHES</th><th>CHEST</th><th>SLEEVE LENGTH</th></tr>
                <tr><td>Small</td><td class='font-monospace'>28</td><td class='font-monospace'>34 - 37</td><td class='font-monospace'>15 ¾</td></tr>
                <tr><td>Medium</td><td class='font-monospace'>29 ¼</td><td class='font-monospace'>38 - 41</td><td class='font-monospace'>17</td></tr>
                <tr><td>Large</td><td class='font-monospace'>30 ¼</td><td class='font-monospace'>42 - 45</td><td class='font-monospace'>18 ¼</td></tr>
                <tr><td>X-Large</td><td class='font-monospace'>31 ¼</td><td class='font-monospace'>46 - 49</td><td class='font-monospace'>19 ½</td></tr>
                <tr><td>2X-Large</td><td class='font-monospace'>32 ½</td><td class='font-monospace'>50 - 53</td><td class='font-monospace'>20 ¾</td></tr>
                <tr><td>3X-Large</td><td class='font-monospace'>33 ½</td><td class='font-monospace'>54 - 57</td><td class='font-monospace'>22</td></tr>
                <tr><th>SIZE</th><th>CENTIMETERS</th><th>CHEST</th><th>SLEEVE LENGTH</th></tr>
                <tr><td>Small</td><td class='font-monospace'>71</td><td class='font-monospace'>86.4 - 94</td><td class='font-monospace'>40</td></tr>
                <tr><td>Medium</td><td class='font-monospace'>74.3</td><td class='font-monospace'>96.5 - 104</td><td class='font-monospace'>43.2</td></tr>
                <tr><td>Large</td><td class='font-monospace'>76.8</td><td class='font-monospace'>106.7 - 114.3</td><td class='font-monospace'>46.4</td></tr>
                <tr><td>X-Large</td><td class='font-monospace'>79.4</td><td class='font-monospace'>116.8 - 124.5</td><td class='font-monospace'>49.5</td></tr>
                <tr><td>2X-Large</td><td class='font-monospace'>82.6</td><td class='font-monospace'>127 - 134.6</td><td class='font-monospace'>52.7</td></tr>
                <tr><td>3X-Large</td><td class='font-monospace'>85</td><td class='font-monospace'>137.2 - 144.8</td><td class='font-monospace'>56</td></tr>
              </table>
            </div>
          </div>
        </div>

        <div class='row my-3'>
          <div class='col text-center'>
            <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
            <a href='#session.user.get_home()#' class='btn btn-nmg-cancel'>Cancel</a>
          </div>
        </div>
      </div>
    </div>
  </form>
</cfoutput>
