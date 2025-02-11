<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Nutrient Entry</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Open+Sans:wght@300&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background: #f3f3f3;
        }

        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            font-size: 1em;
        }

        button {
            padding: 10px 20px;
            font-size: 1em;
            background-color: #861657;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #a05f82;
        }

        .output {
            margin-top: 20px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Enter Food Items (comma-separated)</h2>
        <form action="processFood.jsp" method="post">
            <label for="foodInput">Food Items:</label>
            <input type="text" id="foodInput" name="foodInput" placeholder="e.g., rice,chicken" required />
            <button type="submit">Submit</button>
        </form>
    </div>

</body>
</html>
