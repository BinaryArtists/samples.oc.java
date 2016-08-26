Imports System.IO
Imports System.Text

Public Class Form1

    Public Declare Function RSAGenerateKey Lib "RSAWrapper.dll" (ByVal length As Integer, ByVal privateKey As StringBuilder, ByVal publicKey As StringBuilder) As Integer
    Public Declare Function RSAPublicEncrypt Lib "RSAWrapper.dll" (ByVal publicKey As String, ByVal clearText As String, ByVal data As StringBuilder) As Integer
    Public Declare Function RSAPrivateDecrypt Lib "RSAWrapper.dll" (ByVal privateKey As String, ByVal encryptData As String, ByVal data As StringBuilder) As Integer

    Private Sub GenKey_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GenKey.Click
        Dim result As Integer
        Dim strPrivateKey As StringBuilder
        Dim strPublicKey As StringBuilder
        strPrivateKey = New StringBuilder(2048)
        strPublicKey = New StringBuilder(2048)

        result = RSAGenerateKey(1024, strPrivateKey, strPublicKey)
        If result = 0 Then
            PrivateKey.Text = strPrivateKey.ToString()
            PublicKey.Text = strPublicKey.ToString()
        Else
            Dim log As New StringBuilder
            log.Append("RSAGenerateKey result:")
            log.Append(result)
            System.Console.WriteLine(log.ToString())
        End If
    End Sub

    Private Sub Encrypt_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Encrypt.Click
        Dim result As Integer
        Dim strBuf As StringBuilder

        strBuf = New StringBuilder(500)
        Output.Text = ""

        result = RSAPublicEncrypt(PublicKey.Text.ToString, BlankText.Text, strBuf)
        If result = 0 Then
            Output.Text = strBuf.ToString()
            System.Console.WriteLine("encrypt:" + strBuf.ToString())
        Else
            Dim log As New StringBuilder
            log.Append("RSAPublicEncrypt result:")
            log.Append(result)
            System.Console.WriteLine(log.ToString())
        End If

    End Sub

    Private Sub Decypt_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Decypt.Click
        Dim result As Integer
        Dim strBuf As StringBuilder
        strBuf = New StringBuilder(1024)
        BlankText.Text = ""

        result = RSAPrivateDecrypt(PrivateKey.Text.ToString, Output.Text, strBuf)
        If result = 0 Then
            BlankText.Text = strBuf.ToString()
            System.Console.WriteLine("decrypt:" + strBuf.ToString())
        Else
            Dim log As New StringBuilder
            log.Append("RSAPrivateDecrypt result:")
            log.Append(result)
            System.Console.WriteLine(log.ToString())
        End If

    End Sub
End Class
