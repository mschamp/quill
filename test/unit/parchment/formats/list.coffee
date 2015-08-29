Delta = require('rich-text/lib/delta')
Editor = require('../../../../src/editor')


fdescribe('List', ->
  it('add', ->
    @container.innerHTML = '\
      <p>0123</p>\
      <p>5678</p>\
      <p>0123</p>'
    editor = new Editor(@container)
    editor.formatAt(9, 1, 'list', true)
    expect(editor.getDelta()).toEqualDelta(new Delta()
      .insert('0123\n5678')
      .insert('\n', { list: true })
      .insert('0123\n');
    )
    expect(@container.innerHTML).toEqualHTML('
      <p>0123</p>\
      <ol>\
        <li>5678</li>\
      </ol>\
      <p>0123</p>'
    )
  )

  it('remove', ->
    @container.innerHTML = '\
      <p>0123</p>\
      <ol>\
        <li>5678</li>\
      </ol>\
      <p>0123</p>'
    editor = new Editor(@container)
    editor.formatAt(9, 1, 'list', false)
    expect(editor.getDelta()).toEqualDelta(new Delta().insert('0123\n5678\n0123\n'))
    expect(@container.innerHTML).toEqualHTML('
      <p>0123</p>\
      <p>5678</p>\
      <p>0123</p>'
    )
  )

  fit('add merge', ->
    @container.innerHTML = '\
      <ol><li>0123</li></ol>\
      <p>5678</p>\
      <ol><li>0123</li></ol>'
    editor = new Editor(@container)
    debugger
    editor.formatAt(9, 1, 'list', true)
    expect(editor.getDelta()).toEqualDelta(new Delta()
      .insert('0123')
      .insert('\n', { list: true })
      .insert('5678')
      .insert('\n', { list: true })
      .insert('0123')
      .insert('\n', { list: true });
    )
    expect(@container.innerHTML).toEqualHTML('
      <ol>\
        <li>0123</li>\
        <li>5678</li>\
        <li>0123</li>\
      </ol>'
    )
  )

  it('replace', ->
    @container.innerHTML = '\
      <p>0123</p>\
      <ol>\
        <li>5678</li>\
      </ol>\
      <p>0123</p>'
    editor = new Editor(@container)
    editor.formatAt(9, 1, 'bullet', true)
    expect(editor.getDelta()).toEqualDelta(new Delta()
      .insert('0123\n5678')
      .insert('\n', { bullet: true })
      .insert('0123\n');
    )
    expect(@container.innerHTML).toEqualHTML('
      <p>0123</p>\
      <ul>\
        <li>5678</li>\
      </ul>\
      <p>0123</p>'
    )
  )

  it('replace merge', ->
    @container.innerHTML = '\
      <ol><li>0123</li></ol>\
      <ul><li>5678</li></ul>\
      <ol><li>0123</li></ol>'
    editor = new Editor(@container)
    editor.formatAt(9, 1, 'list', true)
    expect(editor.getDelta()).toEqualDelta(new Delta()
      .insert('0123')
      .insert('\n', { list: true })
      .insert('5678')
      .insert('\n', { list: true })
      .insert('0123')
      .insert('\n', { list: true });
    )
    expect(@container.innerHTML).toEqualHTML('
      <ol>\
        <li>0123</li>\
        <li>5678</li>\
        <li>0123</li>\
      </ol>'
    )
  )

  it('replace split', ->
    @container.innerHTML = '
      <ol>\
        <li>0123</li>\
        <li>5678</li>\
        <li>0123</li>\
      </ol>'
    editor = new Editor(@container)
    editor.formatAt(9, 1, 'bullet', true)
    expect(editor.getDelta()).toEqualDelta(new Delta()
      .insert('0123')
      .insert('\n', { list: true })
      .insert('5678')
      .insert('\n', { bullet: true })
      .insert('0123')
      .insert('\n', { list: true });
    )
    expect(@container.innerHTML).toEqualHTML('
      <ol><li>0123</li></ol>\
      <ul><li>5678</li></ul>\
      <ol><li>0123</li></ol>'
    )
  )
)