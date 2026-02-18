let
    // Access the source folder and target the specific CSV file
    Source_Folder = Folder.Files("your_folder_path"),
    File_Content = Source_Folder{[Name="transaction_records.csv"]}[Content],

    // Import the CSV document with proper encoding and promote headers
    Imported_CSV = Csv.Document(File_Content,[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    Promote_Headers = Table.PromoteHeaders(Imported_CSV, [PromoteAllScalars=true]),

    // Assign standardized data types
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Transaction Date", type date}, 
        {"Buyer First Name", type text}, 
        {"Buyer Last Name", type text}, 
        {"Gender", type text}, 
        {"Buyer Location", type text}, 
        {"Buyer Date of Birth", type date}, 
        {"Payment Method", type text}, 
        {"Quantity Purchased", Int64.Type}, 
        {"Product Code", type text}, 
        {"Sales Representative", type text}
    }, "en-US"),

    // Merge Buyer First and Last Name into a single Full Name column
    Merge_Names = Table.CombineColumns(Set_Data_Types, {"Buyer First Name", "Buyer Last Name"}, Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), "Customer Name"),

    // Professionalize headers for business reporting
    Renamed_Columns = Table.RenameColumns(Merge_Names,{
        {"Buyer Location", "City"}, 
        {"Quantity Purchased", "Quantity"}, 
        {"Sales Representative", "Sales Rep"},
        {"Buyer Date of Birth", "DOB"}
    }),

    // Reorder columns for a logical flow: Transaction Details -> Customer -> Product/Sales
    Reordered_Columns = Table.ReorderColumns(Renamed_Columns, {
        "Transaction Date", "Customer Name", "Customer Age", "Gender", "City", 
        "Quantity", "Product Code", "Sales Rep", "Payment Method", "DOB"
    })
in
    Reordered_Columns
