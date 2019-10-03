/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Atul Dobhal)
* Class Name: XMLParser
* Created Date: 22-Mar-2018
* Description: Parse class for XML generated
*******************************************************************/
public class XMLParser {
	public static String parse(String toParse) {
        DOM.Document doc = new DOM.Document();      
        try {
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();
            
            return walkThrough(root);
            
        } catch (System.XMLException e) {  // invalid XML
            system.debug('Message-->'+e.getMessage());
            return e.getMessage();
        }
    }
    
    private static String walkThrough(DOM.XMLNode node){
		String result = '\n';
		if (node.getNodeType() == DOM.XMLNodeType.COMMENT){
			return 'Comment (' +  node.getText() + ')';
		}
		if (node.getNodeType() == DOM.XMLNodeType.TEXT){
			return 'Text (' + node.getText() + ')';
		}
		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT){
			result += 'Element: ' + node.getName();
			if (node.getText().trim() != '') {
			  result += node.getText().trim();
			}
			if (node.getAttributeCount() > 0) { 
				for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
					result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
				}  
			}
			for (Dom.XMLNode child: node.getChildElements()) {
			  result += walkThrough(child);
			}
			return result;
		}
		return '';  //should never reach here 
	}
}