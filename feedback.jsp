<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback - PCOS Care Hub</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #A7C5EB, #F8EDEB);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: 100vh;
            padding: 20px;
        }

        header {
            width: 100%;
            background: linear-gradient(90deg, #FFA69E, #861657);
            color: white;
            padding: 40px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }

        .feedback-container {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 700px;
            padding: 30px 20px;
            text-align: center;
            margin-top: 20px;
        }

        h1 {
            color: #861657;
            margin-bottom: 20px;
            font-size: 1.8em;
        }

        .big-text {
            font-size: 3rem;
            font-style: italic;
            font-family: "Script MT Bold", "Lucida Handwriting", cursive;
            color: #ffffff;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        label {
            font-size: 1.1em;
            color: #333;
            margin-bottom: 8px;
            text-align: left;
            width: 100%;
        }

        input[type="text"], input[type="email"], textarea, select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 1em;
            box-sizing: border-box;
        }

        textarea {
            resize: none;
            height: 100px;
        }

        button {
            padding: 10px 20px;
            background-color: #861657;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        button:hover {
            background-color: #5b2e80;
        }

        .success-message, .error-message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }

        .success-message {
            background-color: #28a745;
            color: white;
        }

        .error-message {
            background-color: #d9534f;
            color: white;
        }
    </style>
</head>
<body>

<header>
    <div class="big-text">Feedback - PCOS Care Hub</div>
</header>

<div class="feedback-container">
    <h1>We Value Your Feedback</h1>
    <form id="feedbackForm" onsubmit="submitFeedback(event)">
        <label for="nameInput">Your Name:</label>
        <input type="text" id="nameInput" name="name" placeholder="Enter your name" required />

        <label for="emailInput">Your Email:</label>
        <input type="email" id="emailInput" name="email" placeholder="Enter your email" required />

        <label for="websiteLike">Do you like the website?</label>
        <select id="websiteLike" name="websiteLike" required>
            <option value="">Select an option</option>
            <option value="Yes">Yes</option>
            <option value="No">No</option>
        </select>

        <label for="difference">Does it make any difference to your condition?</label>
        <select id="difference" name="difference" required>
            <option value="">Select an option</option>
            <option value="Yes">Yes</option>
            <option value="No">No</option>
        </select>

        <label for="features">Which feature(s) did you find most helpful?</label>
        <input type="text" id="features" name="features" placeholder="e.g., Diet tracking, BMI chart, Exercise routines" required />

        <label for="improvements">What additional features would you like to see?</label>
        <input type="text" id="improvements" name="improvements" placeholder="e.g., Wearable integration, meal reminders" />

        <label for="lifestyleInput">How has this platform affected your lifestyle?</label>
        <textarea id="lifestyleInput" name="lifestyle" placeholder="Describe any changes in your routine, habits, or outlook"></textarea>

        <label for="feedbackInput">Any additional feedback for us:</label>
        <textarea id="feedbackInput" name="feedback" placeholder="Write your suggestions or comments here..."></textarea>

        <button type="submit">Submit Feedback</button>
    </form>

    <div id="responseMessage"></div>
</div>

<script>
    async function submitFeedback(event) {
        event.preventDefault();

        const name = document.getElementById('nameInput').value.trim();
        const email = document.getElementById('emailInput').value.trim();
        const websiteLike = document.getElementById('websiteLike').value;
        const difference = document.getElementById('difference').value;
        const features = document.getElementById('features').value.trim();
        const improvements = document.getElementById('improvements').value.trim();
        const lifestyle = document.getElementById('lifestyleInput').value.trim();
        const feedback = document.getElementById('feedbackInput').value.trim();

        // Validate inputs
        if (!name || !email || !websiteLike || !difference || !features) {
            document.getElementById('responseMessage').innerHTML = `<div class="error-message">Please fill out all required fields.</div>`;
            return;
        }

        // Send the feedback to the backend using AJAX
        try {
            const response = await fetch('store_feedback.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&websiteLike=${encodeURIComponent(websiteLike)}&difference=${encodeURIComponent(difference)}&features=${encodeURIComponent(features)}&improvements=${encodeURIComponent(improvements)}&lifestyle=${encodeURIComponent(lifestyle)}&feedback=${encodeURIComponent(feedback)}`
            });

            const result = await response.text();

            if (result.includes("Thank you for your feedback")) {
                document.getElementById('responseMessage').innerHTML = `<div class="success-message">${result}</div>`;
                document.getElementById('feedbackForm').reset(); // Clear the form
            } else {
                document.getElementById('responseMessage').innerHTML = `<div class="error-message">${result}</div>`;
            }
        } catch (error) {
            document.getElementById('responseMessage').innerHTML = `<div class="error-message">An error occurred while submitting your feedback.</div>`;
            console.error('Error:', error);
        }
    }
</script>

</body>
</html>
