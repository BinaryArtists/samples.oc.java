<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form 重写 Dispose，以清理组件列表。
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Windows 窗体设计器所必需的
    Private components As System.ComponentModel.IContainer

    '注意: 以下过程是 Windows 窗体设计器所必需的
    '可以使用 Windows 窗体设计器修改它。
    '不要使用代码编辑器修改它。
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.GenKey = New System.Windows.Forms.Button
        Me.Encrypt = New System.Windows.Forms.Button
        Me.Decypt = New System.Windows.Forms.Button
        Me.BlankText = New System.Windows.Forms.RichTextBox
        Me.PublicKey = New System.Windows.Forms.RichTextBox
        Me.PrivateKey = New System.Windows.Forms.RichTextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Output = New System.Windows.Forms.RichTextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'GenKey
        '
        Me.GenKey.Location = New System.Drawing.Point(207, 401)
        Me.GenKey.Name = "GenKey"
        Me.GenKey.Size = New System.Drawing.Size(75, 23)
        Me.GenKey.TabIndex = 0
        Me.GenKey.Text = "GenKey"
        Me.GenKey.UseVisualStyleBackColor = True
        '
        'Encrypt
        '
        Me.Encrypt.Location = New System.Drawing.Point(298, 401)
        Me.Encrypt.Name = "Encrypt"
        Me.Encrypt.Size = New System.Drawing.Size(75, 23)
        Me.Encrypt.TabIndex = 1
        Me.Encrypt.Text = "Encrypt"
        Me.Encrypt.UseVisualStyleBackColor = True
        '
        'Decypt
        '
        Me.Decypt.Location = New System.Drawing.Point(379, 401)
        Me.Decypt.Name = "Decypt"
        Me.Decypt.Size = New System.Drawing.Size(75, 23)
        Me.Decypt.TabIndex = 2
        Me.Decypt.Text = "Decrypt"
        Me.Decypt.UseVisualStyleBackColor = True
        '
        'BlankText
        '
        Me.BlankText.Location = New System.Drawing.Point(12, 26)
        Me.BlankText.Name = "BlankText"
        Me.BlankText.Size = New System.Drawing.Size(442, 31)
        Me.BlankText.TabIndex = 3
        Me.BlankText.Text = ""
        '
        'PublicKey
        '
        Me.PublicKey.Location = New System.Drawing.Point(12, 84)
        Me.PublicKey.Name = "PublicKey"
        Me.PublicKey.Size = New System.Drawing.Size(442, 96)
        Me.PublicKey.TabIndex = 4
        Me.PublicKey.Text = ""
        '
        'PrivateKey
        '
        Me.PrivateKey.Location = New System.Drawing.Point(12, 198)
        Me.PrivateKey.Name = "PrivateKey"
        Me.PrivateKey.Size = New System.Drawing.Size(442, 96)
        Me.PrivateKey.TabIndex = 5
        Me.PrivateKey.Text = ""
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(13, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(113, 12)
        Me.Label1.TabIndex = 6
        Me.Label1.Text = "String to encrypt:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(10, 69)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(71, 12)
        Me.Label2.TabIndex = 7
        Me.Label2.Text = "Public Key:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(10, 183)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(77, 12)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Private Key:"
        '
        'Output
        '
        Me.Output.Location = New System.Drawing.Point(12, 317)
        Me.Output.Name = "Output"
        Me.Output.Size = New System.Drawing.Size(442, 63)
        Me.Output.TabIndex = 9
        Me.Output.Text = ""
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(15, 299)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(47, 12)
        Me.Label4.TabIndex = 10
        Me.Label4.Text = "Output:"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 12.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(473, 436)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.Output)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.PrivateKey)
        Me.Controls.Add(Me.PublicKey)
        Me.Controls.Add(Me.BlankText)
        Me.Controls.Add(Me.Decypt)
        Me.Controls.Add(Me.Encrypt)
        Me.Controls.Add(Me.GenKey)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents GenKey As System.Windows.Forms.Button
    Friend WithEvents Encrypt As System.Windows.Forms.Button
    Friend WithEvents Decypt As System.Windows.Forms.Button
    Friend WithEvents BlankText As System.Windows.Forms.RichTextBox
    Friend WithEvents PublicKey As System.Windows.Forms.RichTextBox
    Friend WithEvents PrivateKey As System.Windows.Forms.RichTextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Output As System.Windows.Forms.RichTextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label

End Class
