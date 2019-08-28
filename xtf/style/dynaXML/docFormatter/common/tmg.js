const topAppBarElement = document.querySelector('.mdc-top-app-bar');
const topAppBar = mdc.topAppBar.MDCTopAppBar.attachTo(topAppBarElement);

topAppBar.listen('MDCTopAppBar:nav', function (event) {
    const mainframeElement = window.parent.document.getElementById('mainframe');
    const contentFrameElement = window.parent.document.getElementById('contentframe');
    const contentFrameBodyElement = contentFrameElement.contentDocument.body
    if (mainframeElement.cols == '0%,100%') {
        mainframeElement.cols = '29%,71%';
        contentFrameBodyElement.style.borderLeft = '1px solid gray';
    } else {
        mainframeElement.cols = '0%,100%';
        contentFrameBodyElement.style.borderLeft = 'none';
    }
});

const searchTextFieldElement = document.querySelector('.search-field');
const searchTextField = mdc.textField.MDCTextField.attachTo(searchTextFieldElement);

const settingsIcon = document.querySelector('.settings');
function settingsHandleClick(event) {
    window.parent.content.getDrawer().open = ! window.parent.content.getDrawer().open;
}
settingsIcon.addEventListener('click', settingsHandleClick);