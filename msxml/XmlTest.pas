unit XmlTest;

interface

uses
  TestFrameWork, Classes, Xml;

type
  TXmlTest = class(TTestCase)
  private
    FDoc: TXmlDocument;
    procedure LoadXml( AFile: string );
    procedure LoadXmlAndTest( AFile: string );

    procedure SaveXml();

    procedure CheckParse();
  public
    procedure Setup; override;
    procedure Teardown; override;
  published
    procedure LoadTest;
    procedure ParseNode;
    procedure NodeListTest;

    procedure CreateNode;
    procedure CreateAndRead();
  end;

  function Suite() :ITestSuite;

implementation

uses
  SysUtils,
  TestHlp, MSXML_TLB;

function Suite() :ITestSuite;
begin
  Result := TTestSuite.Create( TXmlTest );
end;


{ TXmlTest }

procedure TXmlTest.CheckParse;
var
  root: IDOMElement;
  node: IDOMNode;
begin
  root := FDoc.DOM.documentElement;

  CheckNotNull( root );
  CheckEquals( root.nodeName, 'RangeFormats' );
  Check( root.hasChildNodes );

  node := root.firstChild;

  CheckNotNull( node );
  CheckEquals( node.nodeName, '#comment' );

  node := node.nextSibling;
  CheckEquals( node.nodeName, 'Colors' );
  Check( node.hasChildNodes );
end;

procedure TXmlTest.CreateAndRead;
var
  root: IDOMElement;
  node: IDOMNode;
  pi: IDOMProcessingInstruction;

  procedure CreateColorItem( AColors: IDOMNode; AItem, AValue: string );
  var
    nColor: IDOMNode;
    attr: IDOMAttribute;
  begin
    with FDoc.DOM do
    begin
      nColor := createNode( NODE_ELEMENT, 'Color', '' );
      attr := createAttribute( 'ItemID' );
      attr.value := AItem;
      nColor.attributes.setNamedItem( attr );

      attr := createAttribute( 'Value' );
      attr.value := AValue;
      nColor.attributes.setNamedItem( attr );

      AColors.appendChild( nColor );
    end;
  end;
begin
  with FDoc.DOM do
  begin
    pi := FDoc.DOM.createProcessingInstruction('xml', 'version="1.0"');
    DefaultInterface.appendChild(pi);

    root := createElement( 'RangeFormats' );
    DefaultInterface.appendChild(root);
    Check( documentElement <> nil);

    node := createNode( NODE_ELEMENT, 'Colors', '' );

    CreateColorItem( node, 'Color1', '$00158860' );
    CreateColorItem( node, 'Color2', '$00F18800' );
    CreateColorItem( node, 'Color3', 'clRed' );
    CreateColorItem( node, 'Color4', 'clLime' );

    root.appendChild( node );
  end;
  SaveXml();

  LoadXmlAndTest( THlpTest.GetAppPath() + 'MyTest.xml' );

  CheckParse();
end;

procedure TXmlTest.CreateNode;
var
  root: IDOMElement;
  node: IDOMNode;
  pi: IDOMProcessingInstruction;
begin
  with FDoc.DOM do
  begin
    pi := FDoc.DOM.createProcessingInstruction('xml', 'version="1.0"');
    DefaultInterface.appendChild(pi);

    root := createElement('RootElem');
    DefaultInterface.appendChild(root);

    Check( documentElement <> nil);
  end;
  SaveXml();
end;

procedure TXmlTest.LoadTest;
begin
  LoadXmlAndTest( THlpTest.GetXMLTestFileName() );
end;

procedure TXmlTest.LoadXml( AFile: string );
begin
  with FDoc.DOM do
  begin
    async             := false;
    validateOnParse   := false;
    resolveExternals  := false;

    load( THlpTest.GetXMLTestFileName() );
  end;
end;

procedure TXmlTest.LoadXmlAndTest( AFile: string );
begin
  CheckNotNull( FDoc );
  Check( FDoc.DOM <> nil );

  LoadXml( AFile );

  CheckNotNull( FDoc.DOM.parseError );
  CheckEquals( FDoc.DOM.parseError.errorCode, 0 );
end;

procedure TXmlTest.NodeListTest;
var
  root: IDOMElement;
  node: IDOMNode;
  nodeList: IDOMNodeList;
  nodeRange1: IDOMNode;
begin
  LoadXmlAndTest( THlpTest.GetXMLTestFileName );

  root := FDoc.DOM.documentElement;

  CheckEquals( root.nodeName, 'RangeFormats' );
  Check( root.hasChildNodes );

  nodeList := root.selectNodes( '//Color' );
  CheckNotNull( nodeList );
  CheckEquals( nodeList.length, 4 );
  CheckEquals( nodeList.item[ 0 ].attributes.length, 2 );
  CheckEquals( nodeList.item[ 0 ].attributes.item[ 0 ].nodeName, 'ItemID' );
  CheckEquals( string(nodeList.item[ 0 ].attributes.item[ 0 ].nodeValue), 'Color1' );

  nodeList := root.selectNodes( '//RangeBorder' );
  CheckNotNull( nodeList );
  CheckEquals( nodeList.length, 6 );

  nodeRange1 := root.selectSingleNode( '//Range[@ItemID = "Range1"]' );
  CheckNotNull( nodeRange1 );
  Check( nodeRange1.hasChildNodes );
  CheckEquals( nodeRange1.firstChild.nodeName, 'RangeName' );
  CheckEquals( nodeRange1.firstChild.text, 'E3:F4' );

  nodeList := nodeRange1.selectNodes( './/RangeBorder' );
  CheckNotNull( nodeList );
  CheckEquals( nodeList.length, 2 );
  CheckEquals( nodeList.item[ 0 ].attributes.length, 1 );
  CheckEquals( nodeList.item[ 0 ].attributes.item[ 0 ].nodeName, 'Item' );
  CheckEquals( string(nodeList.item[ 0 ].attributes.item[ 0 ].nodeValue), '7' );
  CheckEquals( nodeList.item[ 0 ].text, 'Border1' );

  nodeList := nodeRange1.selectNodes( '//RangeBorder' );
  CheckNotNull( nodeList );
  CheckEquals( nodeList.length, 6 );

end;

procedure TXmlTest.ParseNode;
begin
  LoadXmlAndTest( THlpTest.GetXMLTestFileName );

  CheckParse();  
end;

procedure TXmlTest.SaveXml;
var
  name: string;
begin

  name := THlpTest.GetAppPath() + 'MyTest.xml';
  FDoc.DOM.save(name);
end;

procedure TXmlTest.Setup;
begin
  inherited;
  FDoc := Xml.TXmlDocument.create( nil );

  THlpTest.CreateXMLFile();
end;

procedure TXmlTest.Teardown;
begin
  FDoc.Free;
  FDOc := nil;
  inherited;
end;

end.
