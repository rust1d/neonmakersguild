<div id='imageDropdown' class='dropdown position-absolute'>
  <a href='#' class='dropdown-toggle d-none' id='dropdownMenuLink' data-bs-toggle='dropdown' data-bs-auto-close='outside' aria-expanded='false'></a>
  <div class='dropdown-menu px-3 bg-nmg w-500px'>
    <ul class='nav nav-tabs'>
      <li class='nav-item'>
        <a id='tab-drop' class='nav-link active' data-bs-toggle='tab' data-bs-target='#img_drop' aria-current='page' href='#'>
          <span class='input-group-text btn-nmg'><i class='fas fa-upload'></i></span>
        </a>
      </li>
      <li class='nav-item'>
        <a id='tab-link' class='nav-link' data-bs-toggle='tab' data-bs-target='#img_link' aria-current='page' href='#'>
          <span class='input-group-text btn-nmg'><i class='fas fa-link'></i></span>
        </a>
      </li>
      <li class='nav-item ms-auto'>
        <button type='button' class='btn-close ms-auto mt-2' data-bs-dismiss='#imageDropdown' aria-label='Close'></button>
      </li>
    </ul>
    <div class='tab-content'>
      <div class='tab-pane active p-3 border rounded-bottom rounded-end bg-white' id='img_drop' role='tabpanel' aria-labelledby='home-tab' tabindex='0'>
        <h5>Attach Images</h5>
        <div class='border border-dashed border-5 bg-nmg-light rounded text-center px-3' id='uploadDropZone'>
          <div class='fst-italic text-muted my-3'>drop images here to upload</div>
          <button id='btnOpenPicker' type='button' class='btn btn-nmg btn-sm mb-3'>or select files</button>
        </div>
      </div>
      <div class='tab-pane p-3 border rounded-bottom rounded-end bg-white' id='img_link' role='tabpanel' aria-labelledby='profile-tab' tabindex='0'>
        <h5>Attach Images</h5>
        <label class='form-label' for='imageUrlInput'>Image URL</label>
        <input type='text' class='form-control form-control-sm mb-3' id='imageUrlInput' placeholder='https://' />
        <div class='text-center'>
          <button id='btnAttach' type='button' class='btn btn-nmg btn-sm mb-2'>Attach</button>
        </div>
      </div>
    </div>
  </div>
</div>
